require_relative 'validation_error'
require_relative 'recipient'
require 'csv'

module Maildis

  class RecipientParser

    class << self

      @@expected_columns = [:name, :email]

      def valid_csv?(file_path)
        csv = extract_data file_path
        begin
          validate_headers(normalize_headers(csv.headers), @@expected_columns)
          true
        rescue ValidationError => e
          false
        end
      end

      def empty_csv?(file_path)
        csv = extract_data file_path
        csv.empty?
      end

      def extract_recipients(file_path)
        validate_file_path file_path
        csv = extract_data file_path
        validate_headers(normalize_headers(csv.headers), @@expected_columns)
        parse_csv(csv)
      end

      def extract_data(file_path)
        begin
          CSV.read(file_path, {headers: true})
        rescue ArgumentError => e
          begin
            # Force UTF-8
            data = IO.read(file_path).force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
            CSV.parse(data, {headers: true})
          rescue => e
            raise "Failed to parse CSV. Unable to force UTF-8 conversion."+ " " + e.message
          end
        end
      end

      def parse_csv(csv)
        result = []
        csv.each do |r|
          row = {}
          r.to_hash.each_pair {|k,v| row.merge!({k.downcase => v})}
          result << recipient_instance(row)
        end
        result
      end

      def recipient_instance(row)
        recipient = Recipient.new row['name'], row['email']
      end

      def parse_file(file_path)
        IO.read(file_path).force_encoding("ISO-8859-1").encode("utf-8", replace: nil)
      end

      def normalize_headers(headers)
        headers.map(&:downcase)
      end

      def validate_file_path(file_path)
        raise ValidationError, "File not found: #{file_path}" unless File.exists?(file_path)
      end

      def validate_headers(headers, expected)
        expected.each do |header|
          raise ValidationError, "Missing '#{header.to_s}' column" unless headers.include? header.to_s
        end
      end
    end
  end

end
