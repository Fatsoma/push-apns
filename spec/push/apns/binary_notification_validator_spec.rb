describe Push::Apns::BinaryNotificationValidator do
  let(:priority) { 5 }
  let(:alert) { 'Test Alert' }
  let(:badge) { 1 }
  let(:content_available) { nil }
  let(:sound) { 'default' }
  let(:payload_size) { 10 }

  subject do
    Class.new do
      include ActiveModel::Validations

      validates_with Push::Apns::BinaryNotificationValidator

      attr_accessor :priority
      attr_accessor :alert
      attr_accessor :badge
      attr_accessor :content_available
      attr_accessor :sound
      attr_accessor :payload_size

      def initialize(priority, alert, badge, content_available, sound, payload_size)
        @priority = priority
        @alert = alert
        @badge = badge
        @content_available = content_available
        @sound = sound
        @payload_size = payload_size
      end
    end.new(priority, alert, badge, content_available, sound, payload_size)
  end

  context 'when record length < 2048' do
    it 'should be valid' do
      expect(subject).to be_valid
    end
  end

  context 'when record length > 2048' do
    let(:payload_size) { 2080 }

    it 'should not be valid' do
      expect(subject).to_not be_valid
    end
  end

  context 'when storing silent notification' do
    let(:alert) { nil }
    let(:sound) { nil }
    let(:content_available) { 1 }

    context 'with priority of 10' do
      let(:priority) { 10 }
      it 'should not be valid' do
        expect(subject).to_not be_valid
      end
    end

    context 'with priority of 5' do
      it 'should be valid' do
        expect(subject).to be_valid
      end
    end
  end
end
