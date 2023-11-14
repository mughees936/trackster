defmodule TracksterWeb.Router do
  use TracksterWeb, :router

  import TracksterWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {TracksterWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", TracksterWeb do
    pipe_through :browser

    # get "/", PageController, :home
  end

  # Other scopes may use custom stacks.
  # scope "/api", TracksterWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:trackster, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: TracksterWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Authentication routes

  scope "/", TracksterWeb do
    pipe_through [:browser, :redirect_if_user_is_authenticated]

    live_session :redirect_if_user_is_authenticated,
      on_mount: [{TracksterWeb.UserAuth, :redirect_if_user_is_authenticated}] do
      live "/users/log_in", UserLoginLive, :new
      live "/users/reset_password", UserForgotPasswordLive, :new
      live "/users/reset_password/:token", UserResetPasswordLive, :edit
    end

    post "/users/log_in", UserSessionController, :create
  end

  scope "/", TracksterWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{TracksterWeb.UserAuth, :ensure_authenticated}] do
      live "/users/settings", UserSettingsLive, :edit
      live "/users/settings/confirm_email/:token", UserSettingsLive, :confirm_email

      live "/orders", OrderLive.Index, :index
      live "/orders/new", OrderLive.Index, :new
      live "/orders/:id/edit", OrderLive.Index, :edit
      live "/orders/:id", OrderLive.Show, :show
      live "/orders/:id/show/edit", OrderLive.Show, :edit
    end
  end

  scope "/", TracksterWeb do
    pipe_through [:browser, :require_authenticated_admin]

    live_session :require_authenticated_admin,
      on_mount: [{TracksterWeb.UserAuth, :ensure_user_is_admin}] do
      live "/users/register", UserRegistrationLive, :new
    end
  end

  scope "/", TracksterWeb do
    pipe_through [:browser]

    live_session :default,
      on_mount: [{TracksterWeb.UserAuth, :mount_current_user}] do
      live "/", HomeLive.Index, :index
      live "/tracking/:id", OrderTrackingLive.Index, :index
      delete "/users/log_out", UserSessionController, :delete
    end

    live_session :current_user,
      on_mount: [{TracksterWeb.UserAuth, :mount_current_user}] do
      live "/users/confirm/:token", UserConfirmationLive, :edit
      live "/users/confirm", UserConfirmationInstructionsLive, :new
    end
  end
end
