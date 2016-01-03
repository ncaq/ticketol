class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update]

  # GET /contacts
  # GET /contacts.json
  def index
    if current_user.admin?
      allow
      @contacts = Contact.all
    else
      deny
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
    create?
  end

  # GET /contacts/new
  def new
    allow
    @contact = Contact.new
  end

  # GET /contacts/1/edit
  def edit
    if current_user.admin?
      allow
    else
      deny
    end
  end

  # POST /contacts
  # POST /contacts.json
  def create
    create?
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    if current_user.admin?
      allow
      respond_to do |format|
        if @contact.update(contact_params)
          format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
          format.json { render :show, status: :ok, location: @contact }
        else
          format.html { render :edit }
          format.json { render json: @contact.errors, status: :unprocessable_entity }
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
    params.require(:contact).permit(:subject, :request, :response)
  end

  def create?
    if current_user.admin? || current_user.id == @contact.user_id
      allow
    else
      deny
    end
  end
end
