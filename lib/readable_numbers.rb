module Mimbles # :nodoc:
  module ReadableNumbers # :nodoc:
    # Spanish language module
    module Spanish
      # Currency for the +to_currency+ method, change this for your country specific singular currency.
      SP_CURRENCY_SINGULAR = 'peso'
      # Currency for the +to_currency+ method, change this for your country specific plural currency.
      SP_CURRENCY_PLURAL = 'pesos'
      # Cents for the +to_currency+ method, change this for your country specific singular currency.
      SP_CENTS_SINGULAR = 'centavo'
      # Cents for the +to_currency+ method, change this for your country specific plural currency.
      SP_CENTS_PLURAL = 'centavos'
      # M.N. is obligatory in Mexico for invoices, change this for your country or call 
      # <tt>to_currency(false)</tt> to avoid it.
      SP_CURRENCY_X = 'M.N.'
      # Current max limit.
      SP_MAX_NUMBER = 999_999_999_999
      # Holds units.
      SP_UNITS_A = %w(cero uno dos tres cuatro cinco seis siete ocho nueve)
      # Holds teens.
      SP_TEENS_A = %w(diez once doce trece catorce quince dieciseis diecisiete dieciocho diecinueve)
      # Holds tens.
      SP_TENS_A = %w(cero diez veinte treinta cuarenta cincuenta sesenta setenta ochenta noventa)
      # Holds hundreds.
      SP_HUNDREDS_A = %w(_ ciento doscientos trescientos cuatrocientos quinientos seiscientos setecientos ochocientos novecientos)

      # Converts the instance number (for Integer or Float class) to letter.
      # 
      #   123.to_letter
      #   123.15.to_letter
      #   -394.to_letter
      #   0x1A.to_letter
      def to_letter
        num_i = self.to_i
        return 'menos ' + self.abs.to_letter if num_i < 0
      
        decimal = ((self.abs - num_i.abs) * 100).round
        readable_decimal = self.kind_of?(Float) ? " punto #{decimal.to_letter}" : ''
        raise 'Rango soportado actualmente: [- +]999,999,999,999' if num_i > SP_MAX_NUMBER
      
        case num_i.to_s.length
        when 1..2 then   Spanish.read_L1(num_i)
        when 3 then      Spanish.read_L2(num_i)
        when 4..6 then   Spanish.read_L3(num_i)
        when 7..9 then   Spanish.read_L4(num_i)
        when 10..12 then Spanish.read_L5(num_i)
        end.gsub('_', ' ').squeeze(' ').strip.gsub('uno mil', 'un mil') + readable_decimal
      end
    
      # Converts the instance number (for Integer or Float class) to currency.
      # 
      #   123.to_currency
      #   123.15.to_currency
      #   -394.to_currency
      #   0x1A.to_currency
      def to_currency(include_mn = true)
        num_i = self.abs.to_i
        decimal = ((self.abs - num_i.abs) * 100).round
        cents = (decimal == 1) ? Spanish::SP_CENTS_SINGULAR : Spanish::SP_CENTS_PLURAL
        currency = (num_i == 1) ? Spanish::SP_CURRENCY_SINGULAR : Spanish::SP_CURRENCY_PLURAL
        _mn = " #{Spanish::SP_CURRENCY_X}" if include_mn
        readable = num_i.to_letter.gsub('uno', 'un')
        readable += ' de' if (readable =~ /(millon|millones)\z/)      
        readable_decimal = " con #{decimal.to_letter.gsub('uno', 'un')} #{cents}" if self.kind_of?(Float)
      
        "#{readable} #{currency}#{readable_decimal}#{_mn}"
      end
      
      class << self
        # Converts the given *ten* to letter.
        # 
        #   L1 = 1..99
        def read_L1(number)
          num_i = number.to_i
          return SP_UNITS_A[num_i] if num_i < 10
          ten_i, unit_i = num_i.divmod(10)
          case num_i
          when 10..19, 0 then SP_TEENS_A[unit_i]
          when 21..29 then "veinti#{SP_UNITS_A[unit_i]}"
          else SP_TENS_A[ten_i] + (unit_i > 0 ? " y #{SP_UNITS_A[unit_i]}" : '')
          end
        end
    
        # Converts the given *hundred* to letter.
        # 
        #   L2 = 100..999
        def read_L2(number)
          num_i = number.to_i
          hundred_i, ten_i = num_i.divmod(100)
          return 'cien' if num_i == 100
          SP_HUNDREDS_A[hundred_i] + (ten_i > 0 ? " #{read_L1(ten_i)}" : '')
        end
    
        # Converts the given *thousand* to letter.
        # 
        #   L3 = 1,000..9,999
        def read_L3(number)
          num_i = number.to_i
          thousand_i, hundred_i = num_i.divmod(1000)
          thousand_s = case thousand_i
          when 2..9 then SP_UNITS_A[thousand_i]
          when 10..99 then read_L1(thousand_i)
          when 100..999 then read_L2(thousand_i)
          else ''
          end + ' mil '
          thousand_s += read_L2(hundred_i) if hundred_i > 0
          thousand_s
        end
    
        # Converts the given *million* to letter.
        # 
        #   L4 = 1,000,000..999,999,999
        def read_L4(number)
          num_i = number.to_i
          million_i, thousand_i = num_i.divmod(1_000_000)
          million_s = case million_i
          when 1 then 'un millon'
          when 2..9 then SP_UNITS_A[million_i]
          when 10..99 then read_L1(million_i)
          when 100..999 then read_L2(million_i)
          else ''
          end
          million_s += ' millones ' unless million_i == 1
          million_s + case thousand_i
          when 1..999 then read_L2(thousand_i)
          when 1000..999_999 then read_L3(thousand_i)
          else ''
          end
        end
    
        # Converts the given <b>thousands million</b> to letter.
        # 
        #   L5 = 1,000,000,000..999,999,999,999
        def read_L5(number)
          thousand_i, million_i = number.to_i.divmod(1_000_000)
          "#{read_L3(thousand_i)} #{read_L4(million_i)}"
        end
      end
    end
  end
end

Integer.send(:include, Mimbles::ReadableNumbers::Spanish)
Float.send(:include, Mimbles::ReadableNumbers::Spanish)