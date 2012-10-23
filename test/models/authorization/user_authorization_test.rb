#
# Copyright 2012 Red Hat, Inc.
#
# This software is licensed to you under the GNU General Public
# License as published by the Free Software Foundation; either version
# 2 of the License (GPLv2) or (at your option) any later version.
# There is NO WARRANTY for this software, express or implied,
# including the implied warranties of MERCHANTABILITY,
# NON-INFRINGEMENT, or FITNESS FOR A PARTICULAR PURPOSE. You should
# have received a copy of GPLv2 along with this software; if not, see
# http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.

require 'models/user_base'
require 'test/support/auth_support'


class UserAuthorizationAdminTest < MiniTest::Rails::ActiveSupport::TestCase
  include TestUserBase

  def setup
    super
    User.current = User.find(users('admin'))
    @user = User.find(users('no_perms_user'))
  end

  def test_creatable?
    assert User.creatable?
  end

  def test_any_readable?
    assert User.any_readable?
  end

  def test_readable?
    assert @user.readable?
  end

  def test_editable?
    assert @user.editable?
  end

  def test_deletable?
    assert @user.deletable?
  end

  def test_admin_deletable?
    assert !User.current.deletable?
  end

end



class UserAuthorizationNoPermsTest < MiniTest::Rails::ActiveSupport::TestCase
  include TestUserBase

  def setup
    super
    User.current = User.find(users('no_perms_user'))
    @user = User.current
  end

  def test_creatable?
    assert !User.creatable?
  end

  def test_any_readable?
    assert !User.any_readable?
  end

  def test_readable?
    assert !@user.readable?
  end

  def test_editable?
    assert !@user.editable?
  end

  def test_deletable?
    assert !@user.deletable?
  end


end

class UserOrganizationAccess < MiniTest::Rails::ActiveSupport::TestCase
  include AuthorizationSupportMethods
  include TestUserBase

  def setup
    super
    @user = @no_perms_user
    @org = @acme_organization
    @org2 = FactoryGirl.create(:organization, :label=>"foolabel", :name=>"fooname")
  end

  def test_access_two_orgs
    assert @user.allowed_organizations.size == 0
    allow(@user.own_role, [:read], :providers, nil, @org)
    allow(@user.own_role,[:read], :providers, nil, @org2)
    assert @user.allowed_organizations.size == 2
  end
end