module Fog
  module Image
    class OpenStack
      class V2
        class Real
          def set_tenant(tenant)
            @openstack_must_reauthenticate = true
            @openstack_tenant = tenant.to_s
            authenticate
          end
        end

        class Mock
          def set_tenant(_tenant)
            true
          end
        end
      end # class OpenStack
    end
  end # module Compute
end # module Fog
