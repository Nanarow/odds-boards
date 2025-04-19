require 'rails_helper'

RSpec.feature "Boards / Search and Sort", type: :system, js: true do
  describe "searching and sorting boards" do
    given!(:user) { create(:user) }
    given!(:category) { create(:category, creator: user) }
    given!(:board1) { create(:board, title: "Table Board", created_at: 3.days.ago, author: user, category: category, state: :is_published) }
    given!(:board2) { create(:board, title: "Zebra Board", created_at: 2.days.ago, author: user, category: category, state: :is_published) }
    given!(:board3) { create(:board, title: "Apple Board", created_at: 1.day.ago, author: user, category: category, state: :is_published) }

    context "when the user is logged in" do
      background do
        login_as(user, scope: :user)
        visit boards_path
      end

      scenario "searches for boards by keyword" do
        fill_in 'search-input', with: 'Apple'

        expect(page).to have_content('Apple')
        expect(page).to_not have_content('Zebra')
        expect(page).to_not have_content('Table')
      end

      scenario "searches with no results" do
        fill_in 'search-input', with: 'Nonexistent'

        expect(page).to_not have_content('Apple')
        expect(page).to_not have_content('Zebra')
        expect(page).to_not have_content('Table')
      end

      scenario "sorts boards by default creation date descending" do
        titles = find_all('board-title').map(&:text)

        expect(titles).to eq([ 'Apple Board', 'Zebra Board', 'Table Board' ])
      end

      scenario "sorts boards by update date descending" do
        click_on "edit-board-#{board2.id}-button"

        fill_in "board-title-input", with: 'Updated Title'

        click_on "publish-board-button"

        expect(page).to have_content("Updated Title")
        trigger_render_after 1
        expect(page).to have_content("Board was successfully updated.")

        select 'sort-by', with: 'Updated At'
        titles = find_all('board-title').map(&:text)

        expect(titles).to eq([ 'Updated Title', 'Apple Board', 'Table Board' ])
      end

      scenario "sorts boards by title descending" do
        select 'sort-by', with: 'Title'
        titles = find_all('board-title').map(&:text)
        expect(titles).to eq([ 'Zebra Board', 'Table Board', 'Apple Board' ])
      end

      scenario "combines search and sort" do
        fill_in 'search-input', with: 'le'

        expect(page).to have_content('Apple')
        expect(page).to have_content('Zebra')

        select 'sort-by', with: 'Title'
        click_on 'sort-asc-button'

        trigger_render_after 1

        expect(page).to_not have_content('Zebra')
        titles = find_all('board-title').map(&:text)
        expect(titles).to eq([ 'Apple Board', 'Table Board' ])
      end
    end
  end
end
