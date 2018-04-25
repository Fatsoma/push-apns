module Push
  module Apns
    class BinaryNotificationValidator < ActiveModel::Validator
      MAX_PAYLOAD_SIZE = 2048

      def validate(record)
        if record.payload_size > MAX_PAYLOAD_SIZE
          record.errors[:base] << "APN notification cannot be larger than #{MAX_PAYLOAD_SIZE} bytes. Try condensing your alert and device attributes."
        end

        if [5, 10].include?(record.priority) == false
          record.errors[:priority] << "APN priority must be 5 or 10."
        end

        if record.alert.nil? &&
           record.sound.nil? &&
           record.content_available.present? &&
           record.priority == 10
           record.errors[:priority] << "APN priority cannot be 10 for a push that contains only the content_available key."
        end
      end
    end
  end
end
