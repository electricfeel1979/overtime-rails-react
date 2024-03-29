require 'rails_helper'

describe "navigate" do
    let(:user) { FactoryBot.create(:user) }

    let(:post) {
        FactoryBot.create(:post, user: user)
    }

    before do
        login_as(user, :scope => :user)
    end


    describe "index" do
        before do
            visit posts_path
        end

        it 'can be reached successfully' do
            expect(page.status_code).to eq(200)
        end

        it 'has a title of Posts' do
            visit posts_path
            expect(page).to have_content(/Posts/)
        end

        it 'has a list of posts' do
            visit posts_path

            expect(page).to have_content(/Rationale|Content/)
        end

        it 'has a scope so that only post creators can see their posts' do
            non_authorized_user = FactoryBot.create(:non_authorized_user)
            FactoryBot.create(:post_from_other_user, rationale: "This post shouldn't be seen", user: non_authorized_user)

            visit posts_path
            expect(page).to_not have_content("This post shouldn't be seen")
        end
    end

    describe "new" do
        it 'has a link from the homepage' do
            visit posts_path

            click_link 'new_post_from_nav'
            expect(page.status_code).to eq(200)
        end
    end

    describe "delete" do
        it "can be deleted" do
            post
            visit posts_path
            click_link "delete_post_#{post.id}_from_index"
            expect(page.status_code).to eq(200)
        end
    end


    describe "creation" do
        before do
            visit new_post_path
        end

        it 'has a form that can be reached' do
            expect(page.status_code).to eq(200)
        end

        it 'can be created from new form page' do
            fill_in 'post[date]', with: Date.today
            fill_in 'post[rationale]', with: 'Some rationale'

            click_on 'Save'

            expect(page).to have_content("Some rationale")
        end

        it 'will have a user association with' do
            fill_in 'post[date]', with: Date.today
            fill_in 'post[rationale]', with: 'User Association'
            fill_in 'post[overtime_request]', with: 4.5
            click_on 'Save'

            expect(User.last.posts.last.rationale).to eq('User Association')
        end
    end

    describe "edit" do
        it 'can be edited' do
            visit edit_post_path(post.id)

            fill_in 'post[date]', with: Date.today
            fill_in 'post[rationale]', with: 'Edited content'
            click_on 'Save'

            expect(page).to have_content('Edited content')
        end

        it "cannot be edited by a non authorized user" do
            logout(:user)
            non_authorized_user = FactoryBot.create(:non_authorized_user)
            login_as(non_authorized_user, :scope => :user)

            visit edit_post_path(post)

            expect(current_path).to eq(root_path)
        end
    end
end
