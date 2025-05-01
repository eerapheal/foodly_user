import os

def toggle_code(file_path, start_marker, end_marker, disable):
    with open(file_path, 'r') as file:
        lines = file.readlines()

    with open(file_path, 'w') as file:
        inside_block = False
        for line in lines:
            stripped_line = line.strip()
            if start_marker in stripped_line:
                inside_block = True
                if disable:
                    file.write('// ' + stripped_line + '\n')  # Comment the start marker
                else:
                    file.write(stripped_line + '\n')  # Uncomment the start marker
            elif end_marker in stripped_line:
                inside_block = False
                if disable:
                    file.write('// ' + stripped_line + '\n')  # Comment the end marker
                else:
                    file.write(stripped_line + '\n')  # Uncomment the end marker
            elif inside_block:
                if disable:
                    file.write('// ' + line)  # Comment lines inside the block
                else:
                    # Properly format uncommented lines by removing leading slashes and extra spaces
                    uncommented_line = line.lstrip('/ ').rstrip() + '\n'
                    file.write(uncommented_line)
            else:
                file.write(line)

if __name__ == '__main__':
    # List of Dart files to process
    dart_files = ['lib/main.dart',
                  'lib/web_utils/main_web.dart',
                  'lib/controllers/order_controller.dart'
                  ,'lib/controllers/web/order_controller_web.dart',
                  'lib/middlewares/title_middlewares.dart',
                  'lib/views/food/food_page.dart',
                  'lib/web_utils/dynamic_seo.dart',
                  'lib/controllers/feedback_controller.dart',
                  'lib/views/profile/profile_page.dart']

    # Markers to identify the block
    start_marker = '// START_DISABLE'
    end_marker = '// END_DISABLE'

    # Set to True to disable (comment), False to enable (uncomment)
    disable_code_flag = True  # Change to True to disable, False to enable

    for dart_file in dart_files:
        if os.path.exists(dart_file):
            toggle_code(dart_file, start_marker, end_marker, disable_code_flag)
            action = "Disabled" if disable_code_flag else "Enabled"
            print(f"{action} code between {start_marker} and {end_marker} in {dart_file}")
        else:
            print(f"File not found: {dart_file}")
