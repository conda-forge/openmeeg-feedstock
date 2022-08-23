import os
from pathlib import Path
import subprocess
import openmeeg
path = Path(openmeeg.__file__).parent / 'tests'
data_dir = str(Path(os.getcwd()) / 'data')
os.environ['OPENMEEG_DATA_PATH'] = data_dir
print(f'Running tests for {path} using OPENMEEG_DATA_PATH={data_dir}')
subprocess.check_call(['pytest', str(path)])
