require 'spec_helper'

describe Polytexnic::Builders::Html do

  context "in valid tex directory" do
    before { chdir_to_book }

    describe "#build!" do
      subject(:builder) { Polytexnic::Builders::Html.new }
      before { builder.build! }

      its(:built_files) { should include "html/book.html" }

      describe "HTML output" do
        let(:output) { File.read("html/book.html") }
        subject { output }

        it { should match('<!DOCTYPE html>') }
        it { should match('pygments.css') }

      end

      describe "Pygments stylesheet" do
        let(:stylesheet) { 'html/stylesheets/pygments.css' }
        subject { stylesheet }

        it { should exist }
        it "should have a .highlight class" do
          expect(File.read(stylesheet)).to match('.highlight')
        end
      end

      describe "HTML fragments output" do
        let(:output) { File.read('html/chapter-1_fragment.html') }
        subject { output }

        it { should match('Chapter 1') }
      end

      after(:all) do
        chdir_to_book
        builder.clean!
      end
    end
  end

  context "in valid MD directory" do
    before { chdir_to_md_book }

    describe "#build!" do
      subject(:builder) { Polytexnic::Builders::Html.new }

      before { builder.build! }

      2.times do |i|
        its(:built_files) { should include "html/chapter#{i+1}.html" }
        its(:built_files) { should include "html/chapter#{i+1}_fragment.html" }
      end

      after(:all) do
        chdir_to_md_book
        builder.clean!
      end
    end
  end
end