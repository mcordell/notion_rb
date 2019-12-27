# frozen_string_literal: true

module NotionRb
  module Utils
    class Parser
      include NotionRb::Utils::BlockTypes

      def initialize(value, position)
        unless valid_block_type?(value['type'])
          raise ArgumentError, 'Invalid block type'
        end

        @value = value
        @position = position
        @parser = select_parser @value['type']
      end

      def parse
        @parser == :null ? null : base
      end

      private

      def null
        {}
      end

      def base
        {
          notion_id: @value['id'],
          block_type: @value['type'],
          title: @value.dig('properties', 'title', 0, 0),
          parent_id: @value['parent_id'],
          position: @position,
          children: (@value['content'] || []),
          metadata: send("metadata_#{@parser}".to_sym)
        }
      end

      def metadata_base
        {
          color: (@value.dig('properties', 'title', 0, 1, 0, 1) || 'black'),
          block_color: (@value.dig('format', 'block_color') || 'white')
        }
      end

      def metadata_todo
        metadata_base.merge(
          checked: @value.dig('properties', 'checked', 0, 0) == 'Yes'
        )
      end

      def metadata_code
        metadata_base.merge(
          language: @value.dig('properties', 'language', 0, 0)&.downcase
        )
      end

      def metadata_embed
        metadata_base.merge(
          source: @value.dig('properties', 'source', 0, 0)
        )
      end

      def metadata_bookmark
        metadata_base.merge(
          source: @value.dig('properties', 'link', 0, 0)
        )
      end

      def metadata_callout
        metadata_base.merge(
          page_icon: @value.dig('format', 'page_icon')
        )
      end
    end
  end
end
