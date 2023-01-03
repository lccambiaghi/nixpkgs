
try:
    from IPython.core.interactiveshell import InteractiveShell
    InteractiveShell.ast_node_interactivity = "all"
    from IPython.terminal.interactiveshell import TerminalInteractiveShell
    TerminalInteractiveShell.auto_match = True
    print("ipython configured")
except:
    print("error while configuring ipython")

try:
    import pandas as pd
    # pd.set_option('display.max_rows', 999)
    pd.set_option('expand_frame_repr', False)
    pd.set_option('display.max_columns', 100)
    pd.set_option('display.float_format', '{:.2f}'.format)
    print("pandas imported and configured")
except:
    print("pandas was not imported")
