require 'spec_helper'

def heading_titles(heading, title=nil)
  let(:heading) { heading }
  let(:page_title) { title || heading }
end

describe "Static pages" do

  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "Home page" do
    before { visit root_path }
    #let(:heading)    { 'Sample App' }
    #let(:page_title) { '' }
    heading_titles 'Sample App', ''

    it_should_behave_like "all static pages"
    it { should_not have_selector 'title', text: '| Home' }
  end

  describe "Help page" do
    before { visit help_path }
    heading_titles 'Help'

    it_should_behave_like "all static pages"
  end

  describe "About page" do
    before { visit about_path }
    heading_titles 'About', 'About Us'

    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    heading_titles 'Contact'

    it_should_behave_like "all static pages"
  end

  it "should have the right links on the layout" do
    visit root_path
    #click_link "About"
    #page.should have_selector 'title', text: full_title('About Us')
    click_get_page 'About', 'About Us'
    click_get_page 'Help'
    click_get_page 'Contact'
    click_get_page 'Home', ''
    click_get_page 'Sign up now!', 'Sign up'
    click_get_page 'sample app', ''
  end
end