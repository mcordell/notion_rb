# frozen_string_literal: true

SingleCov.covered! uncovered: 4

RSpec.describe NotionRb::Block do
  let(:subject) { NotionRb::Block.new('https://www.notion.so/tpgunther/a-new-title-f0d7f6e4c2284cbab860a6f40ed3372e') }

  after(:each) do
    NotionRb::Utils::BlockCache.instance.clear
  end

  context '#title' do
    it 'gets correct title', :vcr do
      expect(subject.title).to eq 'Testing notion gem'
    end
  end

  context '#title=' do
    it 'sets correct title', :vcr do
      subject.title = 'A new title'
      expect(subject.title).to eq 'A new title'
    end
  end

  context '#type' do
    it 'gets correct type', :vcr do
      expect(subject.type).to eq 'page'
    end
  end

  context '#type=' do
    context 'with invalid type' do
      it 'does not set type', :vcr do
        subject.type = 'non-type'
        expect(subject.type).to eq 'page'
      end
    end

    context 'with valid type' do
      it 'sets correct type', :vcr do
        subject.type = 'toggle'
        expect(subject.type).to eq 'toggle'
      end
    end
  end

  context '#parent' do
    let(:parent) { subject.parent }

    it 'gets parent', :vcr do
      expect(parent.instance_variable_get(:@uuid)).to eq subject.instance_variable_get(:@block)[:parent_id]
    end

    it 'has correct title', :vcr do
      expect(parent.title).to eq 'Inbox'
    end
  end

  context '#children' do
    it 'gets correct children uuid', :vcr do
      expect(subject.children[0].parent.instance_variable_get(:@uuid)).to eq subject.instance_variable_get(:@uuid)
    end

    it "gets children's children", :vcr do
      expect(subject.children[0].title).to eq 'Header 1'
      expect(subject.children[-3].children[0].title).to eq 'Child 1'
    end
  end

  context 'collection_view' do
    let(:subject) { NotionRb::Block.new('0bfbf00d8e7942e5858d2a60f1e20687') }

    context '#children' do
      it 'gets collection children', :vcr do
        expect(subject.children.count).to eq 1
      end

      it 'gets correct type', :vcr do
        expect(subject.children.first.type).to eq 'collection'
      end

      it 'gets correct rows count', :vcr do
        expect(subject.children.first.children.count).to eq 3
      end

      it 'gets correct rows name', :vcr do
        expect(subject.children.first.children.first.title).to eq 'A new name'
      end
    end
  end

  context '#metadata' do
    let(:subject) { NotionRb::Block.new('30e906ba82c04a2191fb5bc21f65b3ef') }

    context 'existing property' do
      it 'gets parents name properties', :vcr do
        expect(subject.respond_to?(:tags)).to eq true
      end

      it 'gets properties', :vcr do
        expect(subject.tags).to eq 'new tag'
      end
    end

    context 'unexisting property' do
      it 'gets properties', :vcr do
        expect { subject.invalid }.to raise_error NoMethodError
      end
    end
  end

  context '#create_child' do
    def create_child_block(uuid)
      allow_any_instance_of(NotionRb::Api::Create).to receive(:block_uuid) { uuid }
      @block = subject.create_child
      @block.type = 'header'
      @block.title = 'Hello'
    end

    it 'creates child with correct title', :vcr do
      create_child_block '6f403974-fac5-4038-a3a2-9c204e794705'
      expect(@block.title).to eq 'Hello'
    end

    it 'creates child with correct type', :vcr do
      create_child_block '37b88087-34f2-40c5-9ea2-252adda55c34'
      expect(@block.title).to eq 'Hello'
    end

    it 'creates child with correct parent', :vcr do
      create_child_block '651c3dcf-a7dc-41a9-bb34-5d52884f1c69'
      expect(@block.parent.instance_variable_get(:@uuid)).to eq subject.instance_variable_get(:@uuid)
    end
  end

  context 'destroy and restore' do
    before do
      @subject = NotionRb::Block.new('13f5a83a5a6f4625a87644cae16b9648')
    end

    context '#destroy' do
      it 'is destroyed', :vcr do
        expect(@subject.destroy).to eq true
      end
    end

    context '#restore' do
      it 'is restored', :vcr do
        expect(@subject.restore).to eq true
      end
    end
  end
end
