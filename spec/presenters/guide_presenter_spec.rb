require 'rails_helper'

RSpec.describe GuidePresenter, type: :presenter do

  let(:file_names)   { ['my/path/some_text.md', 'my/path/and_more_text.md'] }
  let(:renderer)     { instance_double("MarkdownRenderer", render: "some_content") }
  let(:mock_content) { "just some content.." }

  let(:guide_presenter)      { described_class.new(file_names, renderer) }

  describe "#each_rendered_file" do
    it "return result based on block for params" do
      allow(File).to receive(:read).and_return mock_content

      allow(renderer).to receive(:render).with(mock_content).and_return "some_content"
      expect { |probe| guide_presenter.each_rendered_file(&probe) }.
        to yield_successive_args(['some_text', 'some_content'], ['and_more_text', 'some_content'])
    end

    it "passes the files basename and rendered content to the block argument" do
      allow(File).to receive(:read).and_return mock_content

      expect(renderer).to receive(:render).with mock_content
      guide_presenter.each_rendered_file { |name| name }
    end
  end

  describe "#file_names" do
    it "returns all filenames extracted from the paths without file extensions" do
      expect(guide_presenter.file_names).to eq ['some_text', 'and_more_text']
    end
  end

end
