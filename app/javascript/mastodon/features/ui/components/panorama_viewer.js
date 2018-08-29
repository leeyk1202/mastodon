import React from 'react';
import PropTypes from 'prop-types';
import classNames from 'classnames';
import { mat4 } from 'gl-matrix';
import VelocityScroller from '../util/velocity_scroller';

const MAX_ZOOM = 50;
const DEFAULT_INITIAL_ZOOM = 0.8;
const MIN_ZOOM = 0.4;
const WHEEL_ZOOM_SPEED = 0.01;
const PAN_SPEED = 2;
const CLICK_DISTANCE = 4;

// shaders and projection adapted from https://github.com/google/marzipano/tree/5632cd6d3b5ddeb49939aee96e97c24f68874aee
export default class PanoramaViewer extends React.PureComponent {

  static propTypes = {
    image: PropTypes.object.isRequired,
    panoramaData: PropTypes.object.isRequired,
    className: PropTypes.string,
    sphere: PropTypes.number.isRequired,
    onClick: PropTypes.func.isRequired,
  }

  state = {
    yaw: this.props.panoramaData.initialYaw || 0,
    pitch: this.props.panoramaData.initialPitch || 0,
    zoom: this.props.panoramaData.initialFOV ? 1 / this.props.panoramaData.initialFOV : DEFAULT_INITIAL_ZOOM,
    width: 0,
    height: 0,
  }

  constructor (props) {
    super(props);

    this.yawScroller = new VelocityScroller(14, this.props.panoramaData.initialYaw || 0);
    this.pitchScroller = new VelocityScroller(14, this.props.panoramaData.initialPitch || 0);

    this.yawScroller.onUpdate = yaw => {
      this.yawScroller.position = yaw = yaw % (2 * Math.PI);
      this.setState({ yaw });
    };
    this.pitchScroller.onUpdate = pitch => {
      this.pitchScroller.position = pitch = Math.max(-Math.PI / 2, Math.min(pitch, Math.PI / 2));
      this.setState({ pitch });
    };
  }

  get webGLContext() {
    if (!this.canvas) return null;
    this._webGLContext = this._webGLContext || this.canvas.getContext('webgl') || this.canvas.getContext('experimental-webgl');
    return this._webGLContext;
  }

  componentDidMount () {
    window.addEventListener('resize', this.onResize);
    this.onResize();

    this.initWebGL();
  }

  setContainerRef = container => {
    this.container = container;
  }

  setCanvasRef = canvas => {
    this.canvas = canvas;

    if (canvas) {
      // bind WebKit gesture events here because React won't do it
      canvas.addEventListener('gesturestart', this.onGestureStart);
      canvas.addEventListener('gesturechange', this.onGestureChange);

      // passive: false is required for touch events on some browsers (like Firefox 61)
      canvas.addEventListener('touchstart', this.onTouchStart, { passive: false });
      canvas.addEventListener('touchmove', this.onTouchMove, { passive: false });
      canvas.addEventListener('touchend', this.onTouchEnd, { passive: false });
    }
  }

  componentWillUnmount () {
    if (this.canvas) {
      this.canvas.removeEventListener('gesturestart', this.onGestureStart);
      this.canvas.removeEventListener('gesturechange', this.onGestureStart);
    }

    window.removeEventListener('resize', this.onResize);

    if (this.mouseDown) this.onMouseUp();
    if (this.touchDown) this.onTouchEnd();
  }

  screenToYawPitch (dx, dy) {
    const { width, height, zoom } = this.state;
    return [PAN_SPEED * dx / width / zoom, PAN_SPEED * dy / height / zoom];
  }

  applyPointerDelta (dx, dy) {
    let { yaw, pitch } = this.state;
    let [deltaYaw, deltaPitch] = this.screenToYawPitch(dx, dy);
    yaw += deltaYaw;
    pitch += deltaPitch;
    yaw = yaw % (2 * Math.PI);
    pitch = Math.max(-Math.PI / 2, Math.min(pitch, Math.PI / 2));
    this.setState({ yaw, pitch });
  }

  startCoastingWithScreenVelocity(vx, vy) {
    this.yawScroller.position = this.state.yaw;
    this.pitchScroller.position = this.state.pitch;
    const [yawVelocity, pitchVelocity] = this.screenToYawPitch(vx, vy);
    this.yawScroller.velocity = yawVelocity;
    this.pitchScroller.velocity = pitchVelocity;
    this.yawScroller.start();
    this.pitchScroller.start();
  }

  shouldSimulateClick(startPos, endPos) {
    return Math.abs(startPos[0] - endPos[0]) < CLICK_DISTANCE && Math.abs(startPos[1] - endPos[1]) < CLICK_DISTANCE;
  }

  onResize = () => {
    if (this.container) {
      let rect = this.container.getBoundingClientRect();
      this.setState({ width: rect.width, height: rect.height }, () => {
        // for some reason resizing needs an extra draw call
        this.draw();
      });
    }
  }

  onClick = e => {
    // don't propagate event to MediaModal
    e.stopPropagation();
  }

  onMouseDown = e => {
    this.startMousePos = this.lastMousePos = [e.clientX, e.clientY];
    this.lastMouseTime = Date.now();
    this.mouseVelocity = [0, 0];
    this.mouseDown = true;

    this.yawScroller.stop();
    this.pitchScroller.stop();

    window.addEventListener('mousemove', this.onMouseMove);
    window.addEventListener('mouseup', this.onMouseUp);
  }

  onMouseMove = e => {
    const deltaX = e.clientX - this.lastMousePos[0];
    const deltaY = e.clientY - this.lastMousePos[1];
    const now = Date.now();
    const deltaTime = (now - this.lastMouseTime) / 1000;

    this.lastMouseTime = now;
    this.mouseVelocity = [deltaX / deltaTime, deltaY / deltaTime];
    this.applyPointerDelta(deltaX, deltaY);
    this.lastMousePos = [e.clientX, e.clientY];
  }

  onMouseUp = e => {
    this.mouseDown = false;

    if (this.shouldSimulateClick(this.startMousePos, this.lastMousePos)) {
      this.props.onClick(e);
    } else {
      this.startCoastingWithScreenVelocity(...this.mouseVelocity);
    }

    window.removeEventListener('mousemove', this.onMouseMove);
    window.removeEventListener('mouseup', this.onMouseUp);
  }

  onTouchStart = e => {
    e.preventDefault();
    e.stopPropagation();

    this.startTouchPos = this.lastTouchPos = [e.touches[0].clientX, e.touches[0].clientY];
    this.lastTouchTime = Date.now();
    this.touchVelocity = [0, 0];
    this.touchDown = true;

    this.yawScroller.stop();
    this.pitchScroller.stop();
  }

  onTouchMove = e => {
    e.preventDefault();

    const deltaX = e.touches[0].clientX - this.lastTouchPos[0];
    const deltaY = e.touches[0].clientY - this.lastTouchPos[1];
    const now = Date.now();
    const deltaTime = (now - this.lastTouchTime) / 1000;

    this.lastTouchTime = now;
    this.touchVelocity = [deltaX / deltaTime, deltaY / deltaTime];
    this.applyPointerDelta(deltaX, deltaY);
    this.lastTouchPos = [e.touches[0].clientX, e.touches[0].clientY];
  }

  onTouchEnd = e => {
    this.touchDown = false;

    if (this.shouldSimulateClick(this.startTouchPos, this.lastTouchPos)) {
      this.props.onClick(e);
    } else {
      this.startCoastingWithScreenVelocity(...this.touchVelocity);
    }
  }

  onWheel = e => {
    e.preventDefault();

    let zoomDelta = 1 - (e.deltaY * WHEEL_ZOOM_SPEED);
    this.setState({
      zoom: Math.max(MIN_ZOOM, Math.min(this.state.zoom * zoomDelta, MAX_ZOOM)),
    });
  }

  onGestureStart = e => {
    e.preventDefault();

    this.zoomAtGestureStart = this.state.zoom;
  }

  onGestureChange = e => {
    e.preventDefault();

    this.setState({
      zoom: Math.max(MIN_ZOOM, Math.min(this.zoomAtGestureStart * e.scale, MAX_ZOOM)),
    });
  }

  render () {
    const { width, height } = this.state;
    const className = classNames('panorama-viewer', this.props.className || '');

    this.draw();

    return (
      <div className={className} ref={this.setContainerRef}>
        <canvas
          className='panorama-viewer__canvas'
          width={width}
          height={height}
          ref={this.setCanvasRef}

          onMouseDown={this.onMouseDown}
          onWheel={this.onWheel}
          onClick={this.onClick}
        />
      </div>
    );
  }

  initWebGL () {
    const gl = this.webGLContext;

    if (!gl) return;

    gl.clearColor(0, 0, 0, 0);

    const shader = this.compileShader(`
precision highp float;
attribute vec2 position;
uniform mat4 inv_proj;
uniform vec2 flat_scale;
uniform float sphere;
varying vec4 ray;
varying vec2 pos;
void main() {
  gl_Position = vec4(position * mix(flat_scale, vec2(1), sphere), 0., 1.);
  ray = inv_proj * vec4(position, 1., 1.);
  pos = position;
}`, `
precision highp float;
varying vec4 ray;
varying vec2 pos;
uniform sampler2D texture;
uniform float sphere;
uniform vec4 crop;
const float PI = 3.14159265358979323846264;
void main() {
  float r = inversesqrt(ray.x * ray.x + ray.y * ray.y + ray.z * ray.z);
  float phi  = acos(ray.y * r);
  float theta = atan(ray.x, -ray.z);
  float s = 0.5 + 0.5 * theta / PI;
  float t = 1. - phi / PI;

  vec2 tex_pos = vec2(s, 1. - t);
  tex_pos -= crop.xy;
  tex_pos /= crop.zw;
  tex_pos = mix(vec2(1, -1) * pos / 2. + vec2(.5), tex_pos, sphere);
  if (tex_pos.x < 0. || tex_pos.y < 0. || tex_pos.x > 1. || tex_pos.y > 1.) {
    gl_FragColor = vec4(0, 0, 0, 1);
  } else {
    gl_FragColor = texture2D(texture, tex_pos);
  }
}
    `);

    const buffer = gl.createBuffer();
    gl.bindBuffer(gl.ARRAY_BUFFER, buffer);
    gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([
      1, 1,
      -1, 1,
      1, -1,
      -1, -1,
    ]), gl.DYNAMIC_DRAW);

    gl.useProgram(shader);

    const shaderAttribPosition = gl.getAttribLocation(shader, 'position');
    const shaderUniformTexture = gl.getUniformLocation(shader, 'texture');
    const shaderUniformCrop = gl.getUniformLocation(shader, 'crop');
    this.shaderUniformInvProj = gl.getUniformLocation(shader, 'inv_proj');
    this.shaderUniformSphere = gl.getUniformLocation(shader, 'sphere');
    this.shaderUniformFlatImageScale = gl.getUniformLocation(shader, 'flat_scale');

    const {
      fullWidth,
      fullHeight,
      croppedLeft,
      croppedTop,
      croppedWidth,
      croppedHeight,
    } = this.props.panoramaData;

    gl.uniform4f(
      shaderUniformCrop,
      croppedLeft / fullWidth,
      croppedTop / fullHeight,
      croppedWidth / fullWidth,
      croppedHeight / fullHeight
    );

    gl.activeTexture(gl.TEXTURE0);
    gl.uniform1i(shaderUniformTexture, 0);

    gl.vertexAttribPointer(shaderAttribPosition, 2, gl.FLOAT, false, 0, 0);
    gl.enableVertexAttribArray(shaderAttribPosition);

    const texture = gl.createTexture();
    gl.bindTexture(gl.TEXTURE_2D, texture);

    gl.texImage2D(gl.TEXTURE_2D, 0, gl.RGBA, gl.RGBA, gl.UNSIGNED_BYTE, this.props.image);

    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
    gl.texParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);

    this.draw();
  }

  updateProjection (yaw, pitch) {
    const gl = this.webGLContext;
    const { image, sphere } = this.props;
    const { width, height } = this.state;
    if (!gl) return;

    const projection = mat4.create();
    const fov = 1 / this.state.zoom;
    const aspect = width / height;
    mat4.perspective(projection, fov, aspect, -1, 1);
    mat4.rotateX(projection, projection, -pitch);
    mat4.rotateY(projection, projection, -yaw);
    mat4.invert(projection, projection);

    gl.uniform1f(this.shaderUniformSphere, sphere || 0);
    gl.uniformMatrix4fv(this.shaderUniformInvProj, false, projection);

    if (sphere < 1) {
      const rect = image.getBoundingClientRect();
      const scaleX = rect.width / width;
      const scaleY = rect.height / height;
      gl.uniform2f(this.shaderUniformFlatImageScale, scaleX, scaleY);
    }
  }

  draw () {
    const gl = this.webGLContext;
    const { width, height, yaw, pitch } = this.state;
    if (!gl) return;

    gl.viewport(0, 0, width, height);
    gl.clear(gl.COLOR_BUFFER_BIT);
    this.updateProjection(yaw, pitch);
    gl.drawArrays(gl.TRIANGLE_STRIP, 0, 4);
  }

  compileShader (vertex, fragment) {
    const gl = this.webGLContext;

    if (!gl) return null;

    let vert = gl.createShader(gl.VERTEX_SHADER);
    gl.shaderSource(vert, vertex);
    gl.compileShader(vert);

    let frag = gl.createShader(gl.FRAGMENT_SHADER);
    gl.shaderSource(frag, fragment);
    gl.compileShader(frag);

    if (!gl.getShaderParameter(vert, gl.COMPILE_STATUS) || !gl.getShaderParameter(frag, gl.COMPILE_STATUS)) {
      let error = gl.getShaderInfoLog(vert) + '\n\n' + gl.getShaderInfoLog(frag);
      gl.deleteShader(vert);
      gl.deleteShader(frag);
      throw new Error(error);
    }

    let shader = gl.createProgram();
    gl.attachShader(shader, vert);
    gl.attachShader(shader, frag);
    gl.linkProgram(shader);

    if (!gl.getProgramParameter(shader, gl.LINK_STATUS)) {
      let error = gl.getProgramInfoLog(shader);
      gl.deleteProgram(shader);
      throw new Error(error);
    }

    return shader;
  }

  resizeContext () {
    const gl = this.webGLContext;
    const { width, height } = this.state;

    if (!gl) return;

    gl.viewport(0, 0, width, height);
  }

}
