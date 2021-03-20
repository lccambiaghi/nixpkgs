
try:
    from IPython.core.interactiveshell import InteractiveShell
    InteractiveShell.ast_node_interactivity = "all"
    print("ipython configured")
except:
    print("ipython not configured")

try:
    import pandas as pd
    pd.set_option('display.max_rows', 999)
    pd.set_option('expand_frame_repr', False)
    pd.set_option('display.max_columns', 500)
    pd.set_option('display.float_format', '{:.2f}'.format)
    print("pandas imported and configured")
except:
    print("pandas was not imported")
