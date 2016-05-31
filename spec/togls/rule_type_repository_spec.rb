require 'spec_helper'

RSpec.describe Togls::RuleTypeRepository do
  let(:driver_one) { double('driver one') }
  let(:driver_two) { double('driver two') }
  let(:drivers) { [driver_one, driver_two] }
  subject { Togls::RuleTypeRepository.new(drivers) }

  describe '.new' do
    subject { Togls::RuleTypeRepository }

    it 'constructs an instance of rule type repository' do
      drivers = double('drivers')
      repository = subject.new(drivers)
      expect(repository).to be_a(Togls::RuleTypeRepository)
    end

    it 'assigns the drivers' do
      drivers = double('drivers')
      repository = subject.new(drivers)
      expect(repository.instance_variable_get(:@drivers)).
        to eq(drivers)
    end
  end

  describe '#store' do
    it 'stores the given key and klass in the drivers' do
      klass = double('some rule class', title: 'some-title',
                     description: 'some-desc', target_type: :foo_target_type)
      expect(driver_one).to receive(:store).with('some_key', klass.to_s,
                                                 'some-title', 'some-desc',
                                                 'foo_target_type')
      expect(driver_two).to receive(:store).with('some_key', klass.to_s,
                                                 'some-title', 'some-desc',
                                                 'foo_target_type')
      subject.store('some_key', klass)
    end
  end

  describe '#include?' do
    it 'gets the klass for the given type id' do
      expect(subject).to receive(:get_klass).with(:type_id)
      subject.include?(:type_id)
    end

    context 'when the klass can be found in the repository' do
      it 'returns true' do
        allow(subject).to receive(:get_klass).and_return('FoundKlass')
        result = subject.include?(:type_id)
        expect(result).to eql true
      end
    end

    context 'when the klass CANNOT be found in the repository' do
      it 'returns false' do
        allow(subject).to receive(:get_klass).and_return(nil)
        result = subject.include?(:type_id)
        expect(result).to eql false
      end
    end
  end

  describe '#include_klass?' do
    it 'gets the type id for the given class' do
      expect(subject).to receive(:get_type_id).with(Class)
      subject.include_klass?(Class)
    end

    context 'when the type id can be found in the repository' do
      it 'returns true' do
        allow(subject).to receive(:get_type_id).with(Class).and_return('type_id')
        result = subject.include_klass?(Class)
        expect(result).to eql true
      end
    end

    context 'when the type id CANNOT be found in the repository' do
      it 'returns false' do
        allow(subject).to receive(:get_type_id).with(Class).and_return(nil)
        result = subject.include_klass?(Class)
        expect(result).to eql false
      end
    end
  end

  describe '#get_klass' do
    it 'gets the class identified by given key from drivers' do
      klass = double('some rule class')
      expect(driver_two).to receive(:get_klass).with('some_key')
      expect(driver_one).to receive(:get_klass).with('some_key')
      subject.get_klass('some_key')
    end

    it 'short circuits once receiving non-nil value' do
      klass = double('some rule class')
      allow(Object).to receive(:const_get)
      expect(driver_two).to receive(:get_klass).with('some_key').and_return(double)
      expect(driver_one).not_to receive(:get_klass)
      subject.get_klass('some_key')
    end

    it 'returns the the class registered with the type' do
      klass = double('some rule class')
      allow(driver_two).to receive(:get_klass).with('some_key').and_return('some_klass')
      expect(Object).to receive(:const_get).with('some_klass').and_return(klass)
      expect(subject.get_klass('some_key')).to eq(klass)
    end
  end

  describe '#get_type_id' do
    it 'gets the type id given the class from the drivers' do
      klass = Class.new(Togls::Rule)
      expect(driver_two).to receive(:get_type_id).with(klass.to_s).and_return(double)
      subject.get_type_id(klass)
    end
  end
end
