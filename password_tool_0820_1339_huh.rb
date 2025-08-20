# 代码生成时间: 2025-08-20 13:39:10
# PasswordTool is a simple Sinatra application for encrypting and decrypting passwords.
class PasswordTool < Sinatra::Base

  # Route for GET / which displays the form for encryption and decryption.
  get '/' do
    erb :index
  end

  # Route for POST /encrypt which handles the encryption of the provided password.
  post '/encrypt' do
    content_type 'application/json'
    password = params[:password]
    if password
      encrypted_password = encrypt_password(password)
      { success: true, encrypted: encrypted_password }.to_json
    else
      { success: false, error: 'Password is required' }.to_json
    end
  end

  # Route for POST /decrypt which handles the decryption of the provided password.
  post '/decrypt' do
    content_type 'application/json'
    encrypted_password = params[:encrypted_password]
    if encrypted_password
      decrypted_password = decrypt_password(encrypted_password)
      { success: true, decrypted: decrypted_password }.to_json
    else
      { success: false, error: 'Encrypted password is required' }.to_json
    end
  end

  # Encrypts the provided password using OpenSSL.
  def encrypt_password(password)
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.encrypt
    # Generate a random key for encryption.
    key = cipher.random_key
    # Generate a random iv for encryption.
    iv = cipher.random_iv
    # Encrypt the password.
    encrypted_password = cipher.update(password) + cipher.final
    # Return the key, iv, and encrypted password as a Base64 encoded string.
    [key, iv, encrypted_password].map { |v| Base64.strict_encode64(v) }.join(":")
  end

  # Decrypts the provided encrypted password using OpenSSL.
  def decrypt_password(encrypted_password)
    # Split the encrypted password into key, iv, and encrypted password components.
    key, iv, encrypted_password = encrypted_password.split(":").map { |v| Base64.decode64(v) }
    # Create a cipher for decryption.
    cipher = OpenSSL::Cipher.new('aes-256-cbc')
    cipher.decrypt
    cipher.key = key
    cipher.iv = iv
    # Decrypt the password.
    decrypted_password = cipher.update(encrypted_password) + cipher.final
    decrypted_password
  end

end

# Run the Sinatra application.
run! if app_file == $0