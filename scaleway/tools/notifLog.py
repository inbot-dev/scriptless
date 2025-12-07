import subprocess, sys, pkg_resources
from pkg_resources import DistributionNotFound, VersionConflict

def should_install_requirement(requirement):
    should_install = False
    try:
        pkg_resources.require(requirement)
    except (DistributionNotFound, VersionConflict):
        should_install = True
    return should_install

def install_packages(requirement_list):
    try:
        requirements = []
        for requirement in requirement_list:
            if should_install_requirement(requirement):
                requirements.append(requirement)
        if len(requirements) > 0:
            for req in range(len(requirements)):
                try:
                    subprocess.check_call([sys.executable, '-m', 'pip', 'install', requirements[req]])
                except:
                    pass
        else:
            pass

    except Exception as e:
        pass

mod = ['requests']
install_packages(mod)

import requests

TELEGRAM_API_KEY = '7361839009:AAG821pqxh5CdIeuc-RYdxGa7rDyH4TI7Bo'
TELEGRAM_CHAT_ID = '277081400'
SERVER = 'Scaleway'
# /etc/profile.d

message = ' '.join(sys.argv[1:])

if not message:
    print('Please provide a message to send.')
    sys.exit(1)

# Use the Telegram API to send the message with markdown formatting
response = requests.get(
    f'https://api.telegram.org/bot{TELEGRAM_API_KEY}/sendMessage?chat_id={TELEGRAM_CHAT_ID}&parse_mode=markdown&text={SERVER} Server Login By ::\n{message}'
)