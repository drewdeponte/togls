require 'spec_helper'

RSpec.describe Togls::LoggerManagement do
  describe '.logger' do
    context 'when given a value' do
      it 'sets the current value' do
        klass = Class.new do
          include Togls::LoggerManagement
        end

        logger = double('logger')
        wrapped_logger = double('wrapped_logger')
        allow(OptionalLogger::Logger).to receive(:new).with(logger).and_return(wrapped_logger)
        rv = klass.logger(logger)
        expect(klass.instance_variable_get(:@logger)).to eq(wrapped_logger)
        expect(rv).to eq(wrapped_logger)
      end
    end

    context 'when not given a value' do
      context 'when it has previously been set' do
        it 'returns the current value' do
          klass = Class.new do
            include Togls::LoggerManagement
          end

          logger = double('logger')
          wrapped_logger = double('logger')
          klass.instance_variable_set(:@logger, wrapped_logger)
          expect(klass.logger).to eq(wrapped_logger)
        end
      end

      context 'when it has NOT previously been set' do
        it 'returns nil' do
          klass = Class.new do
            include Togls::LoggerManagement
          end

          expect(klass.logger).to be_nil
        end
      end
    end
  end
end
