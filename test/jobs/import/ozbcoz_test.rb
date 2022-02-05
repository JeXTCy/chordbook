require "test_helper"

class Import::OzbcozTest < ActiveJob::TestCase
  test "all" do
    VCR.use_cassette("ozbcoz") do
      assert_enqueued_jobs 3322 do
        Import::Ozbcoz.all
      end
    end
  end

  test "perform" do
    VCR.use_cassette("ozbcoz") do
      assert_difference -> { Songsheet.count } do
        perform_enqueued_jobs only: Import::Chordpro do
          Import::Ozbcoz.perform_now("https://ozbcoz.com/Songs/guitarpdf/pro/Across-The-Universe.pro")
        end
      end

      songsheet = Songsheet.last
      assert_equal "Across The Universe", songsheet.title
      assert_equal({"artist" => "The Beatles", "key" => "C"}, songsheet.metadata)
    end
  end

  test "song with bad encoding" do
    VCR.use_cassette("ozbcoz") do
      assert_difference -> { Songsheet.count } do
        perform_enqueued_jobs only: Import::Chordpro do
          Import::Ozbcoz.perform_now("https://ozbcoz.com/Songs/guitarpdf/pro/Aint-No-Cure-For-Love.pro")
        end
      end

      songsheet = Songsheet.last
      assert_equal "Ain’t No Cure For Love", songsheet.title
    end
  end
end
