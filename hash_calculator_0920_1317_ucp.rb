# 代码生成时间: 2025-09-20 13:17:54
# HashCalculator is a Sinatra application that calculates hash values for provided content.
class HashCalculator < Sinatra::Base

  # Home page that displays a form for inputting content to calculate its hash.
  get '/' do
    erb :index
  end

  # POST endpoint to calculate the hash of the provided content.
  post '/calculate' do
    content = params['content']
    unless content
      halt 400, {'Content-Type' => 'application/json'}, {"error" => "We need some content to calculate a hash."}.to_json
    end

    hash_type = params['hash_type'] || 'sha256'
    begin
      # Calculate the hash of the provided content.
      hash = Digest::Digest.const_get(hash_type).hexdigest(content)
      {
        'Content' => content,
        'HashType' => hash_type,
        'HashValue' => hash
      }.to_json
    rescue StandardError => e
      # Handle any exceptions that occur during hash calculation.
      halt 500, {'Content-Type' => 'application/json'}, {"error" => e.message}.to_json
    end
  end
end

# Define an ERB template for the index page.
__END__

@@index
<!DOCTYPE html>
<html>
<head>
  <title>Hash Calculator</title>
</head>
<body>
  <h1>Hash Calculator</h1>
  <form action="/calculate" method="post">
    <label for="content">Content:</label>
    <textarea id="content" name="content" rows="4" cols="50"></textarea>
    <br>
    <label for="hash_type">Hash Type (optional, default: sha256):</label>
    <input type="text" id="hash_type" name="hash_type" value="sha256">
    <br>
    <input type="submit" value="Calculate Hash">
  </form>
</body>
</html>