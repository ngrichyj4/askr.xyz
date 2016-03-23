require 'rails_helper.rb'

describe Poll do
  context "validations" do
    let(:poll) { create :poll }
    it "permits numbers, upper and lower characters, hyphens, and underscores in the slug" do
      poll.slug = '_-abcdefghijklmnopqrstuvwxyz'
      expect(poll).to be_valid
      poll.slug = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
      expect(poll).to be_valid
    end

    it "does not permit whitespace or other characters in the slug" do
      disallowed = %w(! @ # $ % ^ & * ' " < > |) 
      disallowed << ' '
      disallowed << "\n"
      disallowed << "\t"
      disallowed.each do |invalid_char|
        poll.slug = "invalid#{invalid_char}"
        expect(poll).to_not be_valid
      end
    end

    it "does not permit an empty slug" do
      poll.slug = ''
      expect(poll).to_not be_valid
      poll.slug = nil
      expect(poll).to_not be_valid
    end

    it "does not permit slugs of more than 50 characters" do
      poll.slug = '123456789_123456789_123456789_123456789_123456789_'
      expect(poll).to be_valid
      poll.slug += "1"
      expect(poll).to_not be_valid
    end

    it "permits empty questions" do
      poll.question = ''
      expect(poll).to be_valid
    end

    it "permits voting styles that are present in the ALL_VOTING_STYLES class constant" do
      allow(poll).to receive(:all_voting_styles) { %w(one_style another_style) }
      poll.voting_style = :one_style
      expect(poll).to be_valid
      poll.voting_style = :another_style
      expect(poll).to be_valid
    end

    it "does not permit voting styles not included in ALL_VOTING_STYLES" do
      allow(poll).to receive(:all_voting_styles) { %w(one_style another_style) }
      poll.voting_style = :choose_one
      expect(poll).to_not be_valid
    end

    it "does not get confused by strings instead of symbols for the voting_style" do
      allow(poll).to receive(:all_voting_styles) { %w(one_style another_style) }
      poll.voting_style = "one_style"
      expect(poll).to be_valid
    end

    it "has :choose_one, :choose_any, and :sort in ALL_VOTING_STYLES" do
      poll.voting_style = :choose_one
      expect(poll).to be_valid
      poll.voting_style = :choose_one
      expect(poll).to be_valid
      poll.voting_style = :sort
      expect(poll).to be_valid
    end
  end
end
