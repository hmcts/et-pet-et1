require "rails_helper"

RSpec.describe MarkdownRenderer, type: :service do

  let(:html_renderer) { double }

  before :each do
    allow(Redcarpet::Render::HTML).to receive(:new).and_return html_renderer
  end

  describe "initialize" do
    it "setups a Reccarpet markdown renderer with the table option" do
      expect(Redcarpet::Markdown).to receive(:new).with(html_renderer, tables: true)
      described_class.new
    end
  end

  describe "#render" do

    let(:content_arg)         { "such render.." }
    let(:redcardpet_markdown) { double(render: rendered_content) }
    let(:rendered_content)    { double(html_safe: "some content..") }

    before :each do
      allow(Redcarpet::Markdown).to receive(:new).and_return redcardpet_markdown
    end

    it "proxies the contents through the renderer returning a html safe string" do
      expect(redcardpet_markdown).to receive(:render).with content_arg
      expect(rendered_content).to receive(:html_safe)

      subject.render content_arg
    end
  end
end