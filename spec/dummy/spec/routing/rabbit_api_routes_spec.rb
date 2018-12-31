require 'dummy/spec/rails_helper'

describe 'ApiGuardRoutesSpec', type: :routing do
  describe 'generate all routes for specified resource' do
    it 'should create routes for admin' do
      Rails.application.routes.draw do
        api_guard_routes for: 'admins'
      end

      expect(post: "/admins/sign_up").to route_to('api_guard/registration#create')
      expect(delete: "/admins/delete").to route_to('api_guard/registration#destroy')

      expect(post: "/admins/sign_in").to route_to('api_guard/authentication#create')
      expect(delete: "/admins/sign_out").to route_to('api_guard/authentication#destroy')

      expect(post: "/admins/tokens").to route_to('api_guard/tokens#create')
    end
  end

  describe 'override class name' do
    it 'should create routes for customers with class User' do
      Rails.application.routes.draw do
        api_guard_routes for: 'customers', class_name: 'User'
      end

      expect(post: "/customers/sign_up").to route_to('api_guard/registration#create')
      expect(delete: "/customers/delete").to route_to('api_guard/registration#destroy')

      expect(post: "/customers/sign_in").to route_to('api_guard/authentication#create')
      expect(delete: "/customers/sign_out").to route_to('api_guard/authentication#destroy')

      expect(post: "/customers/tokens").to route_to('api_guard/tokens#create')
    end
  end

  describe 'override route helper name prefix' do
    it 'should create routes for users with helper name prefix "customer"' do
      Rails.application.routes.draw do
        api_guard_routes for: 'users', as: 'customer'
      end

      expect(customer_sign_up_path).to eq('/users/sign_up')
      expect(customer_delete_path).to eq('/users/delete')

      expect(customer_sign_in_path).to eq('/users/sign_in')
      expect(customer_sign_out_path).to eq('/users/sign_out')

      expect(customer_tokens_path).to eq('/users/tokens')
    end
  end

  describe 'override path prefix' do
    it 'should create routes for users with path prefix customers' do
      Rails.application.routes.draw do
        api_guard_routes for: 'users', path: 'customers'
      end

      expect(post: "/customers/sign_up").to route_to('api_guard/registration#create')
      expect(delete: "/customers/delete").to route_to('api_guard/registration#destroy')

      expect(post: "/customers/sign_in").to route_to('api_guard/authentication#create')
      expect(delete: "/customers/sign_out").to route_to('api_guard/authentication#destroy')

      expect(post: "/customers/tokens").to route_to('api_guard/tokens#create')
    end

    it 'should create routes for users with no path prefix' do
      Rails.application.routes.draw do
        api_guard_routes for: 'users', path: ''
      end

      expect(post: "/sign_up").to route_to('api_guard/registration#create')
      expect(delete: "/delete").to route_to('api_guard/registration#destroy')

      expect(post: "/sign_in").to route_to('api_guard/authentication#create')
      expect(delete: "/sign_out").to route_to('api_guard/authentication#destroy')

      expect(post: "/tokens").to route_to('api_guard/tokens#create')
    end
  end

  describe 'override controller' do
    it 'should create registration routes for admins with custom controller' do
      Rails.application.routes.draw do
        api_guard_routes for: 'admins', controller: {
          registration: 'admins/registration',
          authentication: 'admins/auth'
        }
      end

      expect(post: "/admins/sign_up").to route_to('admins/registration#create')
      expect(delete: "/admins/delete").to route_to('admins/registration#destroy')

      expect(post: "/admins/sign_in").to route_to('admins/auth#create')
      expect(delete: "/admins/sign_out").to route_to('admins/auth#destroy')
    end
  end
end
