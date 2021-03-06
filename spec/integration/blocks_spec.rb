# frozen_string_literal: true

SingleCov.not_covered!

RSpec.describe 'All Blocks' do
  let(:blocks) { NotionRb::Api::Get.new(notion_id: 'f0d7f6e4-c228-4cba-b860-a6f40ed3372e').blocks }

  let(:parent) { blocks[0] }
  (2..4).each do |index|
    let("header_#{index - 1}_block".to_sym) { blocks[index] }
    let("bullet_#{index - 1}_block".to_sym) { blocks[index + 3] }
    let("todo_#{index - 1}_block".to_sym) { blocks[index + 6] }
    let("numbered_#{index- 1}_block".to_sym) { blocks[index + 9] }
  end
  let(:text_block) { blocks[14] }
  let(:toggle_block) { blocks[15] }
  let(:toggle_child_block) { blocks[16] }
  let(:quote_block) { blocks[16] }
  let(:divider_block) { blocks[17] }
  let(:link_to_page_block) { blocks[18] }
  let(:callout_block) { blocks[20] }
  let(:image_block) { blocks[21] }
  let(:bookmark_block) { blocks[22] }
  let(:code_block) { blocks[23] }
  let(:file_block) { blocks[24] }
  let(:audio_block) { blocks[25] }
  let(:embed_block) { blocks[26] }

  context 'page parser' do
    it 'parses correctly', :vcr do
      expect(parent[:title]).to eq 'Testing notion gem'
      expect(parent[:block_type]).to eq 'page'
      expect(parent[:position]).to eq 0
      expect(parent[:parent_slug]).to eq nil
    end
  end

  context 'basic text blocks' do
    context 'headers' do
      context 'header 1 parser' do
        it 'parses correctly', :vcr do
          expect(header_1_block[:title]).to eq 'Header 1'
          expect(header_1_block[:block_type]).to eq 'header'
          expect(header_1_block[:parent_id]).to eq parent[:notion_id]
          expect(header_1_block[:metadata][:color]).to eq 'blue'
          expect(header_1_block[:metadata][:block_color]).to eq 'white'
        end
      end

      context 'header 2 parser' do
        it 'parses correctly', :vcr do
          expect(header_2_block[:title]).to eq 'Header 2'
          expect(header_2_block[:block_type]).to eq 'sub_header'
          expect(header_2_block[:parent_id]).to eq parent[:notion_id]
          expect(header_2_block[:position]).to be > header_1_block[:position]
          expect(header_2_block[:metadata][:color]).to eq 'black'
          expect(header_2_block[:metadata][:block_color]).to eq 'blue_background'
        end
      end

      context 'header 3 parser' do
        it 'parses correctly', :vcr do
          expect(header_3_block[:title]).to eq 'Header 3'
          expect(header_3_block[:block_type]).to eq 'sub_sub_header'
          expect(header_3_block[:parent_id]).to eq parent[:notion_id]
          expect(header_3_block[:position]).to be > header_2_block[:position]
          expect(header_3_block[:metadata][:color]).to eq 'black'
          expect(header_3_block[:metadata][:block_color]).to eq 'white'
        end
      end
    end

    context 'bulleted_list parser' do
      it 'parses correctly', :vcr do
        expect(bullet_1_block[:title]).to eq 'bullet 1'
        expect(bullet_1_block[:block_type]).to eq 'bulleted_list'
        expect(bullet_1_block[:parent_id]).to eq parent[:notion_id]
        expect(bullet_1_block[:position]).to be > header_3_block[:position]
        expect(bullet_1_block[:metadata][:color]).to eq 'blue'
        expect(bullet_1_block[:metadata][:block_color]).to eq 'blue_background'

        expect(bullet_2_block[:title]).to eq 'bullet 2'
        expect(bullet_2_block[:block_type]).to eq 'bulleted_list'
        expect(bullet_2_block[:parent_id]).to eq parent[:notion_id]
        expect(bullet_2_block[:position]).to be > bullet_1_block[:position]
        expect(bullet_2_block[:metadata][:color]).to eq 'black'
        expect(bullet_2_block[:metadata][:block_color]).to eq 'white'
      end
    end

    context 'todo parser' do
      it 'parses correctly', :vcr do
        expect(todo_1_block[:title]).to eq 'todo 1'
        expect(todo_1_block[:block_type]).to eq 'to_do'
        expect(todo_1_block[:parent_id]).to eq parent[:notion_id]
        expect(todo_1_block[:position]).to be > bullet_2_block[:position]

        expect(todo_2_block[:title]).to eq 'todo 2'
        expect(todo_2_block[:block_type]).to eq 'to_do'
        expect(todo_2_block[:parent_id]).to eq parent[:notion_id]
        expect(todo_2_block[:position]).to be > todo_1_block[:position]
      end
    end

    context 'numbered list parser' do
      it 'parses correctly', :vcr do
        expect(numbered_1_block[:title]).to eq '1'
        expect(numbered_1_block[:block_type]).to eq 'numbered_list'
        expect(numbered_1_block[:parent_id]).to eq parent[:notion_id]
        expect(numbered_1_block[:position]).to be > bullet_2_block[:position]

        expect(numbered_2_block[:title]).to eq '2'
        expect(numbered_2_block[:block_type]).to eq 'numbered_list'
        expect(numbered_2_block[:parent_id]).to eq parent[:notion_id]
        expect(numbered_2_block[:position]).to be > numbered_1_block[:position]
      end
    end

    context 'text parser' do
      it 'parses correctly', :vcr do
        expect(text_block[:title]).to eq "Multiline\ntext"
        expect(text_block[:block_type]).to eq 'text'
        expect(text_block[:parent_id]).to eq parent[:notion_id]
        expect(text_block[:position]).to be > numbered_2_block[:position]
      end
    end

    context 'toggle parser' do
      it 'parses correctly', :vcr do
        expect(toggle_block[:title]).to eq 'Toggle title'
        expect(toggle_block[:block_type]).to eq 'toggle'
        expect(toggle_block[:parent_id]).to eq parent[:notion_id]
        expect(toggle_block[:position]).to be > text_block[:position]
      end

      it 'parses toggle´s child correctly', :vcr do
        pending('should include childs?')
        expect(toggle_child_block[:title]).to eq 'Content'
        expect(toggle_child_block[:block_type]).to eq 'text'
        expect(toggle_child_block[:parent_id]).to eq parent[:notion_id]
        expect(toggle_child_block[:position]).to be > toggle_block[:position]
      end
    end

    context 'quote parser' do
      it 'parses correctly', :vcr do
        expect(quote_block[:title]).to eq 'A inspiring quote'
        expect(quote_block[:block_type]).to eq 'quote'
        expect(quote_block[:parent_id]).to eq parent[:notion_id]
        expect(quote_block[:position]).to be > toggle_block[:position]
      end
    end

    context 'divider parser' do
      it 'parses correctly', :vcr do
        expect(divider_block[:title]).to eq nil
        expect(divider_block[:block_type]).to eq 'divider'
        expect(divider_block[:parent_id]).to eq parent[:notion_id]
        expect(divider_block[:position]).to be > quote_block[:position]
      end
    end

    context 'link_to_page_block parser' do
      it 'parses correctly', :vcr do
        expect(link_to_page_block[:title]).to eq 'Subchild'
        expect(link_to_page_block[:block_type]).to eq 'page'
        expect(link_to_page_block[:parent_id]).not_to eq parent[:notion_id]
        expect(link_to_page_block[:position]).to be > divider_block[:position]
      end
    end

    context 'callout_block parser' do
      it 'parses correctly', :vcr do
        expect(callout_block[:title]).to eq 'Callout text'
        expect(callout_block[:block_type]).to eq 'callout'
        expect(callout_block[:parent_id]).to eq parent[:notion_id]
        expect(callout_block[:position]).to be > link_to_page_block[:position]
        expect(callout_block[:metadata][:page_icon]).to eq '💡'
        expect(callout_block[:metadata][:block_color]).to eq 'red_background'
      end
    end

    context 'image parser' do
      it 'parses correctly', :vcr do
        expect(image_block[:title]).to eq nil
        expect(image_block[:block_type]).to eq 'image'
        expect(image_block[:parent_id]).to eq parent[:notion_id]
        expect(image_block[:position]).to be > callout_block[:position]
        expect(image_block[:metadata][:caption]).to eq 'caption'
        expect(image_block[:metadata][:source]).to match /https/
      end
    end

    context 'bookmark parser' do
      it 'parses correctly', :vcr do
        expect(bookmark_block[:title]).to eq 'Build software better, together'
        expect(bookmark_block[:block_type]).to eq 'bookmark'
        expect(bookmark_block[:parent_id]).to eq parent[:notion_id]
        expect(bookmark_block[:position]).to be > image_block[:position]
        expect(bookmark_block[:metadata][:source]).to match /https/
      end
    end

    context 'code parser' do
      it 'parses correctly', :vcr do
        expect(code_block[:title]).to eq "puts 'Hello World'"
        expect(code_block[:block_type]).to eq 'code'
        expect(code_block[:parent_id]).to eq parent[:notion_id]
        expect(code_block[:position]).to be > bookmark_block[:position]
        expect(code_block[:metadata][:language]).to eq 'ruby'
      end
    end

    context 'file parser' do
      it 'parses correctly', :vcr do
        expect(file_block[:title]).to eq 'test.txt'
        expect(file_block[:block_type]).to eq 'file'
        expect(file_block[:parent_id]).to eq parent[:notion_id]
        expect(file_block[:position]).to be > code_block[:position]
        expect(file_block[:metadata][:source]).to match /http/
      end
    end

    context 'audio parser' do
      it 'parses correctly', :vcr do
        expect(audio_block[:title]).to eq nil
        expect(audio_block[:block_type]).to eq 'audio'
        expect(audio_block[:parent_id]).to eq parent[:notion_id]
        expect(audio_block[:position]).to be > file_block[:position]
        expect(audio_block[:metadata][:source]).to match /http/
      end
    end

    context 'embed parser' do
      it 'parses correctly', :vcr do
        expect(embed_block[:title]).to eq nil
        expect(embed_block[:block_type]).to eq 'embed'
        expect(embed_block[:parent_id]).to eq parent[:notion_id]
        expect(embed_block[:position]).to be > audio_block[:position]
        expect(audio_block[:metadata][:source]).to match /http/
      end
    end
  end

  context 'advance blocks' do
    let(:table_block) { NotionRb::Api::Get.new(notion_id: '0bfbf00d-8e79-42e5-858d-2a60f1e20687').blocks[0] }

    it 'gets correct table parser', :vcr do
      expect(table_block[:title]).to eq nil
      expect(table_block[:notion_id]).to eq '0bfbf00d-8e79-42e5-858d-2a60f1e20687'
      expect(table_block[:block_type]).to eq 'collection_view_page'
      expect(table_block[:parent_id]).to eq '393db0d9-1794-4eab-81f4-7b19eaf5ed96'
      expect(table_block[:metadata][:collection_id]).to eq '1f564fea-8711-480c-9cb8-9d56ce5beb68'
      expect(table_block[:metadata][:view_ids]).to eq ['e9c7a91e-b4dd-4eb4-9418-0957c2d1444b']
    end
  end
end
