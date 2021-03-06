require 'rails_helper'

RSpec.describe Plate, type: :model do

  describe '#size' do
    it "returns its size" do
      expect(build(:plate).size).to eq(96)
    end
  end

  describe '#positions' do

    context 'when both dimensions are not alpha' do

      before do
        labware_type = create(:plate_labware_type, x_dimension_size: 3, y_dimension_size: 3)
        @plate = create(:plate, labware_type: labware_type)
      end

      it 'returns an array of integers for each of its well names' do
        expect(@plate.positions).to eq((1..9).to_a)
      end

    end

    context 'when x_dimension_is_alpha is true' do

      before do
        labware_type = create(:plate_labware_type, x_dimension_size: 3, y_dimension_size: 3, x_dimension_is_alpha: true)
        @plate = create(:plate, labware_type: labware_type)
      end

      it 'returns an array with letters for the x dimension' do
        expected = ['1A', '1B', '1C', '2A', '2B', '2C', '3A', '3B', '3C']
        expect(@plate.positions).to eq(expected)
      end

    end

    context 'when y_dimension_is_alpha is true' do

      before do
        labware_type = create(:plate_labware_type, x_dimension_size: 3, y_dimension_size: 3, y_dimension_is_alpha: true)
        @plate = create(:plate, labware_type: labware_type)
      end

      it 'returns an array with letters for the y dimension' do
        expected = ['A1', 'A2', 'A3', 'B1', 'B2', 'B3', 'C1', 'C2', 'C3']
        expect(@plate.positions).to eq(expected)
      end

    end

  end


end
