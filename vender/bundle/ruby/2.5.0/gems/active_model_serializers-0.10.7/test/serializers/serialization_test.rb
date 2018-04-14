module ActiveModel
  class Serializer
    class SerializationTest < ActiveSupport::TestCase
      class Blog < ActiveModelSerializers::Model
        attributes :id, :name, :authors
      end
      class Author < ActiveModelSerializers::Model
        attributes :id, :name
      end
      class BlogSerializer < ActiveModel::Serializer
        attributes :id
        attribute :name, key: :title

        has_many :authors
      end
      class AuthorSerializer < ActiveModel::Serializer
        attributes :id, :name
      end

      setup do
        @authors = [Author.new(id: 1, name: 'Blog Author')]
        @blog = Blog.new(id: 2, name: 'The Blog', authors: @authors)
        @serializer_instance = BlogSerializer.new(@blog)
        @serializable = ActiveModelSerializers::SerializableResource.new(@blog, serializer: BlogSerializer, adapter: :attributes)
        @expected_hash = { id: 2, title: 'The Blog', authors: [{ id: 1, name: 'Blog Author' }] }
        @expected_json = '{"id":2,"title":"The Blog","authors":[{"id":1,"name":"Blog Author"}]}'
      end

      test '#serializable_hash is the same as generated by the attributes adapter' do
        assert_equal @serializable.serializable_hash, @serializer_instance.serializable_hash
        assert_equal @expected_hash, @serializer_instance.serializable_hash
      end

      test '#as_json is the same as generated by the attributes adapter' do
        assert_equal @serializable.as_json, @serializer_instance.as_json
        assert_equal @expected_hash, @serializer_instance.as_json
      end

      test '#to_json is the same as generated by the attributes adapter' do
        assert_equal @serializable.to_json, @serializer_instance.to_json
        assert_equal @expected_json, @serializer_instance.to_json
      end

      test '#to_h is an alias for #serializable_hash' do
        assert_equal @serializable.serializable_hash, @serializer_instance.to_h
        assert_equal @expected_hash, @serializer_instance.to_h
      end

      test '#to_hash is an alias for #serializable_hash' do
        assert_equal @serializable.serializable_hash, @serializer_instance.to_hash
        assert_equal @expected_hash, @serializer_instance.to_hash
      end
    end
  end
end
