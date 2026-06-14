module Api
  module V1
    class CertificatesController < ApplicationController
      include Authenticable
      skip_before_action :verify_authenticity_token
      before_action :authorize_member

      # GET /api/v1/certificates
      def index
        certificates = @current_user.certificates.includes(:course).order(issued_at: :desc)

        render json: {
          certificates: certificates.map { |c| serialize(c) }
        }, status: :ok
      end

      # GET /api/v1/certificates/:id
      def show
        certificate = @current_user.certificates.find_by(id: params[:id])

        unless certificate
          render json: { error: 'Certificate not found' }, status: :not_found
          return
        end

        render json: { certificate: serialize(certificate) }, status: :ok
      end

      private

      def serialize(certificate)
        {
          id: certificate.id,
          code: certificate.code,
          course_id: certificate.course_id,
          course_title: certificate.course.title,
          issued_at: certificate.issued_at&.utc&.iso8601
        }
      end

      def authorize_member
        unless @current_user&.role == 'member'
          render json: { error: 'Access denied. Members only.' }, status: :forbidden
        end
      end
    end
  end
end
