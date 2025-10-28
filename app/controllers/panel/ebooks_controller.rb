module Panel
  class EbooksController < BaseController
    before_action :set_ebook, only: [:show, :edit, :update, :destroy]

    def index
      @ebooks = current_panel_user.ebooks.order(created_at: :desc)
      
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @ebooks = @ebooks.where("title LIKE ? OR author LIKE ? OR description LIKE ?", search_term, search_term, search_term)
      end
      
      if params[:active].present?
        @ebooks = @ebooks.where(active: params[:active] == 'true')
      end
      
      @ebooks = @ebooks.page(params[:page]).per(12)
    end

    def show
    end

    def new
      @ebook = Ebook.new
    end

    def create
      @ebook = current_panel_user.ebooks.build(ebook_params)
      
      if params[:cover].present?
        @ebook.cover.attach(params[:cover])
      end
      
      if params[:file].present?
        @ebook.file.attach(params[:file])
      end

      if @ebook.save
        redirect_to panel_ebooks_path, notice: 'Ebook criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if params[:cover].present?
        @ebook.cover.attach(params[:cover])
      end
      
      if params[:file].present?
        @ebook.file.attach(params[:file])
      end

      if @ebook.update(ebook_params)
        redirect_to panel_ebooks_path, notice: 'Ebook atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @ebook.destroy
      redirect_to panel_ebooks_path, notice: 'Ebook deletado com sucesso!'
    end

    private

    def set_ebook
      @ebook = current_panel_user.ebooks.find(params[:id])
    end

    def ebook_params
      params.require(:ebook).permit(:title, :description, :author, :pages, :active)
    end
  end
end
