require 'rails_helper.rb'

describe Poll do
  context "associations" do
    let(:poll) { build(:poll) }
    it "has many poll_options as options" do
      expect(poll).to have_many(:options)
    end

    it "accepts nested attributes for options" do
      expect(poll).to accept_nested_attributes_for(:options)
    end

    it "allows you to create many options easily" do
      options = {
        slug: 'anything',
        options_attributes: [
          { text: 'first' },
          { text: 'second' },
          { text: 'third' }
        ]
      }
      full_poll = Poll.create(options)
      expect(full_poll.options.count).to eq 3
      expect(full_poll.options.first.to_s).to eq 'first'
    end

    it "ignores options with emtpy text" do
      options = {
        slug: 'anything',
        options_attributes: [
          { text: '' },
          { text: '' },
          { text: 'third' }
        ]
      }
      full_poll = Poll.create(options)
      expect(full_poll.options.count).to eq 1
    end

    it "handles option creation with the input that the default client sends" do
      options = {"slug"=>"drugged-uneducated-person", "question"=>"do you like eggs", "voting_style"=>"choose_one", "options_attributes"=>{"0"=>{"text"=>"first"}, "1"=>{"text"=>"second"}, "2"=>{"text"=>"third"}, "3"=>{"text"=>""}, "4"=>{"text"=>"fourth"}, "5"=>{"text"=>""}, "6"=>{"text"=>""}, "7"=>{"text"=>""}, "8"=>{"text"=>""}, "9"=>{"text"=>""}}}
      full_poll = Poll.create(options)
      expect(full_poll.options.count).to eq 4
      expect(full_poll.options.map(&:to_s)).to eq %w(first second third fourth)
    end
  end

  context "defaults" do
    it "provides a random slug" do
      allow(RandomWord.adjs).to receive(:next).and_return "fluorescent"
      allow(RandomWord.nouns).to receive(:next).and_return "hippo"
      new_poll = Poll.new
      expect(new_poll.slug).to eq 'fluorescent-hippo'
    end

    it "tries again if the slug is too long" do
      allow(RandomWord.adjs).to receive(:next).and_return "123456789_123456789_123456789_", "shorter"
      allow(RandomWord.nouns).to receive(:next).and_return "123456789_123456789_123456789_", "words"
      expect(Poll.new.slug).to eq "shorter-words"
    end

    it "tries again until a unique slug is found" do
      allow(RandomWord.adjs).to receive(:next).and_return "fluorescent", "pastey", "good"
      allow(RandomWord.nouns).to receive(:next).and_return "hippo", "spain", "bait"
      Poll.create(slug: "fluorescent-hippo")
      Poll.create(slug: "pastey-spain")
      poll = Poll.new
      expect(poll).to be_valid
      expect(poll.slug).to eq "good-bait"
    end

    it "doesn't generate a random slug if it already has one" do
      expect(RandomWord.adjs).to_not receive(:next)
      expect(RandomWord.nouns).to_not receive(:next)
      Poll.create slug: 'something-else'
    end

    it "doesn't try indefinitely if it can't find a unique value" do
      expect(RandomWord.adjs).to receive(:next).and_return("intense").at_most(11).times
      expect(RandomWord.nouns).to receive(:next).and_return("fruit").at_most(11).times
      Poll.create slug: "intense-fruit"
      new_poll = Poll.new
    end

    it "leaves the slug empty if it can't randomize a unique value" do
      allow(RandomWord.adjs).to receive(:next).and_return("intense")
      allow(RandomWord.nouns).to receive(:next).and_return("fruit")
      Poll.create slug: "intense-fruit"
      expect(Poll.new.slug).to be_nil
    end

    it "converts underscores in randomized words to hyphens" do
      allow(RandomWord.adjs).to receive(:next).and_return("ultra_flavourful")
      allow(RandomWord.nouns).to receive(:next).and_return("egg_salad")
      expect(Poll.new.slug).to eq "ultra-flavourful-egg-salad"
    end

    it "does not override existing slug" do
      poll = create :poll
      fetched_poll = Poll.find poll.id
      expect(fetched_poll.slug).to eq poll.slug
    end
  end

  context "validations" do
    let(:poll) { create :poll }
    it "requires a unique slug" do
      second_poll = Poll.new(slug: poll.slug)
      expect(second_poll).to_not be_valid
    end

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

    it "permits empty voting style" do
      poll.voting_style = nil
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
