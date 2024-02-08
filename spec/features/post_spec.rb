require 'rails_helper'

describe "navigate" do
    before do
        @user = FactoryBot.create(:user)
        login_as(@user, :scope => :user)
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
            FactoryBot.build_stubbed(:post, user: @user)
            FactoryBot.build_stubbed(:post, user: @user)
            visit posts_path
            expect(page).to have_content(/Rationale|Content/)
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
            click_on 'Save'

            expect(User.last.posts.last.rationale).to eq('User Association')
        end
    end
end
