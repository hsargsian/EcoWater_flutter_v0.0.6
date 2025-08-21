# Path to the .env file
env_file=".local_cd.env"
cd local_cd_pipeline

# Check if the .env file exists
if [ -f "$env_file" ]; then
    # Read each line in the .env file
    while IFS= read -r line || [[ -n "$line" ]]; do
        # Extract variables and values using grep and cut
        variable=$(echo "$line" | grep -o "^[^#]*" | cut -d= -f1)
        value=$(echo "$line" | grep -o "^[^#]*" | cut -d= -f2-)
        
        # Check if the variable is apple_id or apple_app_secret
        if [ "$variable" = "apple_id" ]; then
            apple_id="$value"
        elif [ "$variable" = "apple_app_secret" ]; then
            apple_app_secret="$value"
        elif [ "$variable" = "ipa_file_name" ]; then
            ipa_file_name="$value"
        elif [ "$variable" = "project_id" ]; then
            project_id="$value"
        fi
    done < "$env_file"
else
    echo ".env file not found."
    exit 1
fi

if [ -f "local_cd_pipeline_info_log_file.log" ]; then
    rm local_cd_pipeline_info_log_file.log
fi

cd ..

# you want ios build?

flutter build ipa --release --flavor prod --target lib/main_prod.dart --export-options-plist=local_cd_pipeline/ExportOptions.plist
upload_output=$(xcrun altool --upload-app --type ios -f build/ios/ipa/"$ipa_file_name".ipa -u "$apple_id" -p "$apple_app_secret" 2>&1)
if [ $? -eq 0 ]; then
    echo "Upload successful!"
else
    echo "Upload failed"
    sh local_cd_pipeline/local_cd_pipeline_info_logger.sh "Upload failed"
    sh local_cd_pipeline/local_cd_pipeline_info_logger.sh " "
    sh local_cd_pipeline/local_cd_pipeline_info_logger.sh " "
    sh local_cd_pipeline/local_cd_pipeline_info_logger.sh "Error Information:"
    sh local_cd_pipeline/local_cd_pipeline_info_logger.sh "$upload_output"
fi

