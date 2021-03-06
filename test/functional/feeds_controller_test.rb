require "test_helper"

class FeedsControllerTest < ActionController::TestCase
  signed_in_admin_context do
    def setup
      @request.host = 'cit.local.host'
      @user = User.make

      WorkLog.delete_all
      10.times { WorkLog.make(:user => @user, :company => @user.company) }
    end

    should "render rss" do
      get :rss, { :id => @user.uuid }
      assert_response :success
    end

    should "render ical" do
      get :ical, { :id => @user.uuid }
      assert_response :success
    end

    should "be able to unsubscribe" do
      user = User.make(:newsletter => 1, :uuid => "1234567890abcdefghijklmnopqrstuv")
      assert_equal 1, user.newsletter
      get :unsubscribe, :id => user.uuid 
      assert_equal 0, user.reload.newsletter
      assert_response :success
      assert @response.body.index("unsubscribed")
    end
  end
end 
