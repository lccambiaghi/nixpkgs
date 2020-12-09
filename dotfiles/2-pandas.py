try:
    import pandas as pd
    pd.set_option('display.max_rows', 999)
    pd.set_option('expand_frame_repr', False)
    pd.set_option('display.max_columns', 500)
    pd.set_option('precision', 2)
    pd.set_option('display.float_format', '{:.2f}'.format)
    print("pandas imported and configured")
except:
    print("pandas was not imported")
