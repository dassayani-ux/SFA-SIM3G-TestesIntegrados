import os, sys
from datetime import datetime

def robot_WithHeadless_exe():
    args = sys.argv[1:]
    argumento = ' '.join(str(arg) for arg in args)

    now = datetime.now()
    CURRENT_TIME = now.strftime("%d-%m-%y_%H-%M-%S")

    config_helper_path = "-V ./resources/utils/config_helper.py"
    current_time = "-v CURRENT_TIME:" + CURRENT_TIME

    os.system(f"echo ==============================================================================")
    os.system(f"echo DADOS DA EXECUÇÃO")
    os.system(f"echo ==============================================================================")
    # os.system(f"poetry run robot -L trace -d report/{CURRENT_TIME}/logs {config_helper_path} {headless} {current_time} {argumento} -i planoRegressao test")
    os.system(f"robot -L trace -d report/{CURRENT_TIME}/logs {config_helper_path} {current_time} {argumento} -i planoRegressao test/")


robot_WithHeadless_exe()