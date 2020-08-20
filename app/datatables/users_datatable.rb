class UsersDatatable < ApplicationDatatable
  delegate :edit_user_path, to: :@view
    
  def initialize(users, view)
    super(view)
    @initial_users = users
    @initial_count = users.count
  end

  private

  def data
    users.map do |user|
      [].tap do |column|
        column << user.first_name
        column << user.last_name
        column << user.email
        column << user.phone_number

        links = []
        links << link_to('Show', user)
        links << link_to('Edit', edit_user_path(user))
        links << link_to('Destroy', user, method: :delete, data: { confirm: 'Are you sure?' })
        column << links.join(' | ')
      end
    end
  end

  def count
    #User.count
    @initial_count
  end

  def total_entries
    users.total_count
    # will_paginate
    # users.total_entries
  end

  def users
    @users ||= fetch_users
  end
    
  def fetch_users
    users = @initial_users
    users = users.page(page).per(per_page)
  end

  def fetch_users_orig
    search_string = []
    columns.each do |term|
      search_string << "#{term} like :search"
    end

    # will_paginate
    # users = User.page(page).per_page(per_page)
    users = User.order("#{sort_column} #{sort_direction}")
    users = users.page(page).per(per_page)
    users = users.where(search_string.join(' or '), search: "%#{params[:search][:value]}%")
  end

  def columns
    %w(first_name last_name email phone_number)
  end

end