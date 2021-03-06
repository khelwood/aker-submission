class MaterialSubmission < ApplicationRecord


  belongs_to :labware_type, optional: true
  belongs_to :contact, optional: true
  accepts_nested_attributes_for :contact, update_only: true

  has_many :material_submission_labwares, dependent: :destroy
  has_many :labwares, through: :material_submission_labwares

  validates :no_of_labwares_required, numericality: { only_integer: true, greater_than_or_equal_to: 1 },
    if: :active_or_labware?

  validates :supply_labwares, inclusion: { in: [true, false] }, if: :active_or_labware?
  validates :labware_type_id, presence: true, if: :active_or_labware?
  validates :address, presence: true, if: :active?
  validates :contact, presence: true, if: :active?
  validate :contact_has_a_correct_email?, if: :active?
  validate :each_labware_has_biomaterial, if: :active?

  before_save :set_labware, if: -> { labware_type_id_changed? || no_of_labwares_required_changed? }

  accepts_nested_attributes_for :labwares

  scope :active, -> { where(status: 'active') }
  scope :pending, -> { where.not(status: 'active') }

  def active?
    status == 'active'
  end

  def active_or_labware?
    return false if status.nil?
    active? || status.include?('labware')
  end

  def active_or_provenance?
    return false if status.nil?
    active? || status.include?('provenance')
  end

  def active_or_dispatch?
    return false if status.nil?
    active? || status.include?('dispatch')
  end

  def no_of_labwares_required
    super || 0
  end

  private

  def set_labware
    self.labwares = LabwareType.create_labwares(number: no_of_labwares_required, labware_type_id: labware_type_id)
  end

  def each_labware_has_biomaterial
    unless labwares.all? { |labware| labware.biomaterials.count > 0 }
      errors.add(:labwares, "must each have at least one Biomaterial")
    end
  end

  def contact_has_a_correct_email?
    if contact.email.empty?
      errors.add(:contact, "must have an email")
    end
  end

end
