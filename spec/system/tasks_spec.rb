require 'rails_helper'

# require 'selenium-webdriver'
# require 'nokogiri'
# #
# options = Selenium::WebDriver::Chrome::Options.new
# options.add_argument('--headless')
# options.add_argument('--disable-gpu')
#
# driver = Selenium::WebDriver.for :chrome, options: options

describe 'タスク管理機能', type: :system do
  describe '一覧表示機能' do
    # 下準備として、ユーザーA（user_a）とユーザーB（user_b）をletでわかりやすく定義する
    let(:user_a) { FactoryBot.create(:user, name: 'ユーザーA', email: 'a@example.com') }
    let(:user_b) { FactoryBot.create(:user, name: 'ユーザーB', email: 'b@example.com') }

    before do
      FactoryBot.create(:task, name: '最初のタスク', user: user_a) # これがuser_aの初利用となるので、この時点でユーザーAが実際にデータベースに登録
      visit login_path
      fill_in 'メールアドレス', with: login_user.email
      fill_in 'パスワード', with: login_user.password
      click_button 'ログインする'
    end

    context 'ユーザーAがログインしているとき' do
      let(:login_user) { user_a }

      it 'ユーザーAが作成したタスクが表示される' do
        expect(page).to have_content '最初のタスク'
      end
    end

    context 'ユーザーBがログインしているとき' do
      let(:login_user) { user_b } # ユーザーBでログインするケースでは、初めてuser_bというletが使われ、まずデータベースにユーザーBが登録され、user_bにユーザーBのオブジェクトが入り、それがlogin_userとして利用される。

      it 'ユーザーAが作成したタスクが表示されない' do
        expect(page).to have_no_content '最初のタスク'
      end
    end
  end
end
