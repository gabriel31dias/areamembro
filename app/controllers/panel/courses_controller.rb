module Panel
  class CoursesController < BaseController
    before_action :set_course, only: [:show, :edit, :update, :destroy]

    def index
      @courses = current_panel_user.courses.order(created_at: :desc)
      
      # Busca
      if params[:search].present?
        search_term = "%#{params[:search]}%"
        @courses = @courses.where("title LIKE ? OR description LIKE ?", search_term, search_term)
      end
      
      # Filtro por status
      if params[:active].present?
        @courses = @courses.where(active: params[:active] == 'true')
      end
      
      @courses = @courses.page(params[:page]).per(9)
    end

    def show
    end

    def new
      @course = Course.new
      # Inicia sem aulas, usuário adiciona com botão +
    end

    def create
      @course = current_panel_user.courses.build(course_params)
      
      if params[:photo].present?
        @course.photo.attach(params[:photo])
      end

      if @course.save
        redirect_to panel_courses_path, notice: 'Curso criado com sucesso!'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if params[:photo].present?
        @course.photo.attach(params[:photo])
      end

      if @course.update(course_params)
        redirect_to panel_course_path(@course), notice: 'Curso atualizado com sucesso!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @course.destroy
      redirect_to panel_courses_path, notice: 'Curso deletado com sucesso!'
    end

    private

    def set_course
      @course = current_panel_user.courses.find(params[:id])
    end

    def course_params
      params.require(:course).permit(
        :title, :description, :total_lessons, :active,
        lessons_attributes: [:id, :title, :description, :video_url, :order_number, :duration_minutes, :_destroy]
      )
    end
  end
end
