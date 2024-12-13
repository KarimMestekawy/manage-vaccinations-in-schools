# frozen_string_literal: true

describe AppDetailsComponent do
  subject(:rendered) { render_inline(component) { content } }

  let(:summary) { "A summary" }
  let(:content) { "A content" }
  let(:component) { described_class.new(summary:) }

  it { should have_css(".nhsuk-details") }
  it { should have_css(".nhsuk-details__summary", text: summary) }

  it "defaults to being closed" do
    expect(rendered).to have_css(
      ".nhsuk-details__text",
      text: content,
      visible: :hidden
    )
  end

  context "open flag is true" do
    let(:component) { described_class.new(summary:, open: true) }

    it "displays the content section" do
      expect(rendered).to have_css(
        ".nhsuk-details__text",
        text: content,
        visible: :visible
      )
    end
  end
end
