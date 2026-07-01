module Api
  module V1
    class QuizzesController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member

      # GET /api/v1/lessons/:lesson_id/quiz
      # Retorna o quiz da aula com perguntas e alternativas (sem revelar a resposta correta).
      def show
        lesson = Lesson.find_by(id: params[:lesson_id])
        quiz = lesson&.quiz

        unless quiz
          render json: { error: 'Quiz not found' }, status: :not_found
          return
        end

        unless lesson.course&.accessible_by?(@current_user)
          render json: { error: 'Você não tem um plano compatível com este curso.', has_access: false }, status: :forbidden
          return
        end

        render json: {
          quiz: {
            id: quiz.id,
            title: quiz.title,
            passing_score: quiz.passing_score,
            questions: quiz.questions.map do |q|
              {
                id: q.id,
                statement: q.statement,
                order_number: q.order_number,
                options: q.question_options.map { |o| { id: o.id, text: o.text } }
              }
            end
          }
        }, status: :ok
      end

      # POST /api/v1/quizzes/:id/submit
      # Body: { "answers": { "<question_id>": <option_id>, ... } }
      def submit
        quiz = Quiz.find_by(id: params[:id])

        unless quiz
          render json: { error: 'Quiz not found' }, status: :not_found
          return
        end

        unless quiz.lesson&.course&.accessible_by?(@current_user)
          render json: { error: 'Você não tem um plano compatível com este curso.', has_access: false }, status: :forbidden
          return
        end

        answers = (params[:answers] || {}).to_unsafe_h
        result = quiz.grade(answers)

        attempt = quiz.quiz_attempts.create!(
          user: @current_user,
          score: result[:score],
          passed: result[:passed]
        )

        # "Mestre dos Testes": passar pela primeira vez em um quiz
        Achievement.unlock(@current_user, :quiz_master) if result[:passed]

        render json: {
          attempt: {
            id: attempt.id,
            score: result[:score],
            passed: result[:passed],
            correct: result[:correct],
            total: result[:total],
            passing_score: quiz.passing_score,
            submitted_at: attempt.submitted_at.utc.iso8601
          }
        }, status: :ok
      end

      private

      def authorize_member
        unless @current_user&.role == 'member'
          render json: { error: 'Access denied. Members only.' }, status: :forbidden
        end
      end
    end
  end
end
