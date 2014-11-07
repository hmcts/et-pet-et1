require 'rails_helper'

RSpec.describe GuidePresenter, type: :presenter do

  let(:file_names)  { %w<my/path/some_text.md my/path/and_more_text.md> }
  let(:renderer)    { double("a_mock_renderer", render: "some_content") }
  let(:mock_content){ "just some content.." }

  let(:subject)     { described_class.new(file_names, renderer) }

  describe "#each_rendered_file" do
    it "passes the files basename and rendered content to the block argument" do
      allow(File).to receive(:read).and_return mock_content

      expect(renderer).to receive(:render).with mock_content
      expect{|probe| subject.each_rendered_file &probe}.
        to yield_successive_args(%w<some_text some_content>, %w<and_more_text some_content>)
    end
  end

  describe "#file_names" do
    it "returns all filenames extracted from the paths without file extensions" do
      expect(subject.file_names).to eq %w<some_text and_more_text>
    end
  end

end
