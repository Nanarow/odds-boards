require 'rails_helper'

RSpec.feature "Boards / Search and Sort", type: :system, js: true do
  describe "searching and sorting boards" do
    given!(:user) { create(:user) }
    given!(:category) { create(:category, creator: user) }
    given!(:board1) { create(:board, title: "Zebra Board", created_at: 2.days.ago, author: user, category: category, state: :is_published) }
    given!(:board2) { create(:board, title: "Apple Board", created_at: 1.day.ago, author: user, category: category, state: :is_published) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit boards_path
      end

      scenario "searches for boards by keyword" do
        pending "Implement: Use fill_in 'search-input', with: 'Apple'; click_on 'search-button'; expect have('board') with 'Apple Board', not 'Zebra Board'"
      end

      scenario "searches with no results" do
        pending "Implement: Use fill_in 'search-input', with: 'Nonexistent'; click_on 'search-button'; expect have('no-results')"
      end

      scenario "sorts boards by title ascending" do
        pending "Implement: Use select 'sort-by-select', with: 'Title'; select 'sort-direction-select', with: 'Ascending'; click_on 'sort-button'; expect have('board') with titles in order ['Apple Board', 'Zebra Board']"
      end

      scenario "sorts boards by views descending" do
        pending "Implement: Use select 'sort-by-select', with: 'Views'; select 'sort-direction-select', with: 'Descending'; click_on 'sort-button'; expect have('board') with titles in order ['Apple Board', 'Zebra Board']"
      end

      scenario "sorts boards by creation date ascending" do
        pending "Implement: Use select 'sort-by-select', with: 'Created At'; select 'sort-direction-select', with: 'Ascending'; click_on 'sort-button'; expect have('board') with titles in order ['Zebra Board', 'Apple Board']"
      end

      scenario "combines search and sort" do
        pending "Implement: Use fill_in 'search-input', with: 'Test'; click_on 'search-button'; select 'sort-by-select', with: 'Title'; select 'sort-direction-select', with: 'Ascending'; click_on 'sort-button'; expect have('board') with filtered and ordered results"
      end

      scenario "persists search when sorting" do
        pending "Implement: Use fill_in 'search-input', with: 'Test'; click_on 'search-button'; select 'sort-by-select', with: 'Title'; click_on 'sort-button'; expect have('search-input') with value 'Test'"
      end

      scenario "updates search results dynamically via Turbo Stream" do
        pending "Implement: Use fill_in 'search-input', with: 'Apple'; click_on 'search-button'; expect have('search-results') with updated content"
      end

      scenario "updates sort results dynamically via Turbo Stream" do
        pending "Implement: Use select 'sort-by-select', with: 'Title'; click_on 'sort-button'; expect have('search-results') with updated order"
      end

      scenario "sorts without searching" do
        pending "Implement: Use select 'sort-by-select', with: 'Views'; select 'sort-direction-select', with: 'Descending'; click_on 'sort-button'; expect have('board') with all boards sorted"
      end
    end
  end
end
