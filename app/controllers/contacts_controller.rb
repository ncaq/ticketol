class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update]

  # GET /contacts
  def index
    allow
    @contacts = can_contact_all
  end

  # GET /contacts/1
  def show
    if current_user && current_user.id == @contact.user_id || current_user.admin?
      allow
    else
      deny
    end
  end

  # GET /contacts/new
  def new
    if current_user
      allow
      @contact = Contact.new
    else
      deny
    end
  end

  # GET /contacts/1/edit
  def edit
    if current_user && current_user.admin?
      allow
    else
      deny
    end
  end

  # POST /contacts
  def create
    allow
    @contact = Contact.new(contact_params) { |c|
      c.user = current_user
    }

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /contacts/1
  def update
    if current_user && current_user.admin?
      allow
      respond_to do |format|
        if @contact.update(contact_params)
          format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        else
          format.html { render :edit }
        end
      end
    else
      deny
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_contact
    @contact = Contact.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def contact_params
    permits = [:subject, :request]
    if current_user && current_user.admin?
      permits << :response
    end
    params.require(:contact).permit(permits)
  end

  def can_contact_all
    if current_user
      if current_user.admin?
        return Contact.all
      else
        return Contact.where(user_id: current_user.id)
      end
    else
      return []
    end
  end
end
