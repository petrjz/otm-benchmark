import os
import pandas as pd
import numpy as np
from scipy.stats import norm

def performance_stats(filename):
    file_path = os.path.join(filename)

    try:
        data = pd.read_csv(file_path, header=None, comment='#', quotechar='"', delim_whitespace=True)
    except Exception as e:
        result = {'mean': np.nan}
        return result

    values = data.iloc[:, 0]
    result = {
        'mean': values.mean(),
        'sd': values.std(),
        'ci_lower': values.mean() - norm.ppf(0.975) * (values.std() / np.sqrt(len(values))),
        'ci_upper': values.mean() + norm.ppf(0.975) * (values.std() / np.sqrt(len(values))),
    }
    return result


factor = 4
number_of_reports = 300*factor
mode = ["-read-only", ""]
op = ["retrieve", "retrieve-all"]
for o in op:
    r = {}
    for m in mode:
        # result = performance_stats(f"../data/1g/factor{factor}/jopa-benchmark{m}_{o}.data")
        # result = performance_stats(f"../_data/data-cache-disabled/1g/factor{factor}/jopa-benchmark{m}_{o}.data")
        result = performance_stats(f"../_data/data-cache-enabled/1g/factor{factor}/jopa-benchmark{m}_{o}.data")
        result['mean'] = round(result['mean'], 2)
        result['sd'] = round(result['sd'], 2)
        result['ci_lower'] = round(result['ci_lower'], 2)
        result['ci_upper'] = round(result['ci_upper'], 2)
        r[m] = result
    print(o)
    print("$\\overline{T}$ (ms) ", end="&")
    print(str(r["-read-only"].get("mean")) + "&     " + str(r[""].get("mean")) + "      \\cr")

    print("$\\sigma$ (ms) ", end="&")
    print(str(r["-read-only"].get("sd")) + "&     " + str(r[""].get("sd")) + "          \\cr")

    print("$CI_{95}$ (ms) ", end="&")
    print("(" + str(r["-read-only"].get("ci_lower")) + ";" + str(r["-read-only"].get("ci_upper")) + ")" + "&     " + "(" + str(r[""].get("ci_lower")) + ";" + str(r[""].get("ci_upper")) + ")" + "          \\cr")

    print("$\overline{TPS}$ (\# of reports)", end="&") #457                & 468         \cr
    ro_tps = round(number_of_reports/(r["-read-only"].get("mean")/1000), 2)
    rw_tps = round(number_of_reports/(r[""].get("mean")/1000), 2)
    print(str(ro_tps) + "&     " + str(rw_tps) + "      \\cr")

