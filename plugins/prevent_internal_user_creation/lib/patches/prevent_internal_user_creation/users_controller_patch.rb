require_dependency 'users_controller'

module PreventInternalUserCreation
  module UsersControllerPatch
    def self.included(base)
      base.send(:include, InstanceMethods)

      base.class_eval do
        alias_method_chain :create, :limited_source
        alias_method_chain :update, :limited_source
      end
    end

    module InstanceMethods
      def create_with_limited_source
        @user = User.new
        @user.safe_attributes = params[:user]

        auth_source = params[:user][:auth_source_id]

        if auth_source && (auth_source.empty? || auth_source.nil?)
          flash[:error] = 'Autenticazione interna non autorizzata'
          @auth_sources = AuthSource.all
          respond_to do |format|
            format.html { render action: :new }
          end
        else
          create_without_limited_source
        end
      end

      def update_with_limited_source
        auth_source = params[:user][:auth_source_id]

        if auth_source && (auth_source.empty? || auth_source.nil?)
          flash[:error] = 'Autenticazione interna non autorizzata'
          @auth_sources = AuthSource.all
          respond_to do |format|
            format.html { render action: :edit }
          end
        else
          update_without_limited_source
        end
      end
    end
  end
end

UsersController.send(:include, PreventInternalUserCreation::UsersControllerPatch)
