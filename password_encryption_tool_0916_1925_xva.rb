# 代码生成时间: 2025-09-16 19:25:59
# PasswordEncryptionTool is a Sinatra app that provides
# functionality for encrypting and decrypting passwords.
class PasswordEncryptionTool < Sinatra::Base
  # Set the port and enable logging for development
  port 4567
  set :logging, true

  # Home page with options for encrypting and decrypting
  get '/' do
    "<html><body>
  <h2>Password Encryption Tool</h2>
  <form action='/encrypt' method='post'>
    <input type='text' name='password' placeholder='Enter password to encrypt' required/>
    <button type='submit'>Encrypt</button>
  </form>
  <form action='/decrypt' method='post'>
    <input type='text' name='encrypted_password' placeholder='Enter encrypted password to decrypt' required/>
    <button type='submit'>Decrypt</button>
  </form>
  </body></html>"
  end

  # Route to handle password encryption
  post '/encrypt' do
    password = params['password']
    unless password.nil? || password.empty?
      # Encrypt the password using OpenSSL
      encrypted_password = OpenSSL::Cipher.new('AES-256-CBC').encrypt
      encrypted_password.pkcs5_keyivgen(ENV['PASSWORD_KEY']) if ENV['PASSWORD_KEY']
      encrypted_password.update(password) + encrypted_password.final
      "<html><body><h3>Encrypted Password:</h3><p>#{Rack::Utils.escape_html(encrypted_password)}</p></body></html>"
    else
      halt 400, 'Password cannot be empty'
    end
  end

  # Route to handle password decryption
  post '/decrypt' do
    encrypted_password = params['encrypted_password']
    unless encrypted_password.nil? || encrypted_password.empty?
      # Decrypt the password using OpenSSL
      cipher = OpenSSL::Cipher.new('AES-256-CBC').decrypt
      cipher.pkcs5_keyivgen(ENV['PASSWORD_KEY']) if ENV['PASSWORD_KEY']
      decrypted_password = cipher.update(encrypted_password) + cipher.final
      "<html><body><h3>Decrypted Password:</h3><p>#{Rack::Utils.escape_html(decrypted_password)}</p></body></html>"
    else
      halt 400, 'Encrypted password cannot be empty'
    end
  end

  # Error handling for 400 errors
  error 400 do
    '<html><body><h3>Error 400: Bad Request</h3><p>Please check your input and try again.</p></body></html>'
  end
end

# Run the Sinatra app if this file is executed directly
run! if __FILE__ == $0