$:.unshift File.join(File.dirname(__FILE__),'..','lib')

require 'test/unit'
require 'readable_numbers'

class ReadableNumbersTest < Test::Unit::TestCase
  def test_ten
    assert_equal("uno", 1.to_letter)
    assert_equal("cero", 0.to_letter)
    assert_equal("diez", 10.to_letter)
    assert_equal("veintiuno", 21.to_letter)
    assert_equal("treinta", 30.to_letter)
    assert_equal("noventa y nueve", 99.to_letter)
    assert_equal("menos dos", -2.to_letter)
    assert_equal("dos pesos M.N.", 0b10.to_currency)
    assert_equal("trece punto doce", 13.12.to_letter)
    assert_equal("menos noventa punto catorce", -90.14.to_letter)
    assert_equal("menos cuarenta y cinco", -45.to_letter)
    assert_equal("un peso M.N.", 1.to_currency)
    assert_equal("once pesos", 11.to_currency(false))
    assert_equal("un peso con diez centavos M.N.", 1.10.to_currency)
    assert_equal("diez pesos con cero centavos M.N.", -10.0.to_currency)
  end
  
  def test_hundred
    assert_equal("cien", 100.to_letter)
    assert_equal("ciento uno", 101.to_letter)
    assert_equal("ciento veintidos", 122.to_letter)
    assert_equal("doscientos", 200.to_letter)
    assert_equal("quinientos diez", 510.to_letter)
    assert_equal("trescientos cincuenta", 350.to_letter)
    assert_equal("doscientos cuarenta punto ocho", 240.08.to_letter)
    assert_equal("menos novecientos ochenta y nueve", -989.to_letter)
    assert_equal("novecientos nueve pesos M.N.", 909.to_currency)
    assert_equal("ciento un pesos", 101.to_currency(false))
    assert_equal("cien pesos con un centavo", 100.01.to_currency(false))
  end
  
  def test_thousand
    assert_equal("mil", 1000.to_letter)
    assert_equal("dos mil", 2000.to_letter)
    assert_equal("cuatro mil punto doce", 4000.12.to_letter)
    assert_equal("menos mil doscientos uno", -1201.to_letter)
    assert_equal("nueve mil novecientos noventa y nueve", 9999.to_letter)
    assert_equal("mil pesos M.N.", 1000.to_currency)
    assert_equal("tres mil un pesos", 3001.to_currency(false))
  end
  
  def test_million
    assert_equal("un millon", 1_000_000.to_letter)
    assert_equal("dos millones", 2_000_000.to_letter)
    assert_equal("cinco millones doscientos uno punto sesenta", 5_000_201.60.to_letter)
    assert_equal("cien millones doscientos treinta y un mil cuatrocientos uno", 100_231_401.to_letter)
    assert_equal("un millon diez pesos M.N.", 1_000_010.to_currency)
    assert_equal("trescientos millones de pesos", 300_000_000.to_currency(false))
    assert_equal("un millon de pesos M.N.", 1_000_000.to_currency)
  end
  
  def test_thousand_million
    assert_equal("mil millones", 1_000_000_000.to_letter)
    assert_equal("doscientos mil millones uno", 200_000_000_001.to_letter)
    assert_equal("once mil millones trescientos cuarenta mil punto cincuenta", 11_000_340_000.50.to_letter)
    assert_equal("diez mil millones de pesos M.N.", 10_000_000_000.to_currency)
    assert_equal("dos mil millones ciento cuarenta y ocho pesos", 2_000_000_148.to_currency(false))
  end
  
  def test_limit
    assert_raise(RuntimeError) { 1_000_000_000_000.to_letter }
    assert_raise(RuntimeError) { 1_000_000_000_000.35.to_letter }
    assert_raise(RuntimeError) { -1_000_000_000_000.to_letter }
  end
end