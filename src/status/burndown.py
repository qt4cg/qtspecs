import sys
import json
import math
from datetime import datetime, timedelta
import dateutil.parser
from dateutil.tz import tzutc
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

meetingone = datetime(2022, 9, 6, 16, 0, 0, tzinfo=tzutc())
meetingnow = datetime.now().astimezone()
oneweek = timedelta(days=7)
weekcount = math.floor((meetingnow - meetingone) / oneweek)
specifications = ['XQFO', 'XDM', 'XPath', 'XQuery', 'XQUF', 'XSLT', 'unspecified']
features = ['feature', 'enhancement', 'other']

# Work back six months
firstweek = weekcount - 27
print(firstweek)

def compute_weeks(issue):
    opendate = dateutil.parser.isoparse(issue.get("created_at"))
    if opendate <= meetingone:
        firstweek = 0
    else:
        firstweek = math.floor((opendate - meetingone) / oneweek)
    issue['week_open'] = firstweek

    if issue["closed_at"]:
        closdate = dateutil.parser.isoparse(issue.get("closed_at"))
        if closdate <= meetingone:
            lastweek = 0
        else:
            lastweek = math.floor((closdate - meetingone) / oneweek)
        issue['week_closed'] = lastweek

    return issue

def issue_labels(issue):
    labels = []
    for label in issue['labels']:
        labels.append(label['name'])
    return labels

def feature_label(labels):
    if 'Feature' in labels:
        return 'feature'
    elif 'Enhancement' in labels:
        return 'enhancement'
    else:
        return 'other'

def specification_label(labels):
    for spec in specifications:
        if spec in labels:
            return spec
    return 'unspecified'

weeks = []
for week in range(0, weekcount+2):
    initial = {
        'issue': {'opened': 0, 'closed': 0},
        'feature': {'opened': 0, 'closed': 0},
        'enhancement': {'opened': 0, 'closed': 0},
        'other': {'opened': 0, 'closed': 0}}
    for spec in specifications:
        initial[spec] = {'opened': 0, 'closed': 0}
    weeks.append(initial)

issues = {}
with open("qtspecs-issues.json", "r", encoding="utf-8") as file:
    for issue in json.load(file):
        if issue['number'] in issues:
            raise RuntimeError(f"Duplicate issue: {issue['number']}")
        if 'pull_request' not in issue:
            issue = compute_weeks(issue)
            labels = issue_labels(issue)

            featureLabel = feature_label(labels)
            specLabel = specification_label(labels)
            
            weeks[issue['week_open']]['issue']['opened'] += 1
            weeks[issue['week_open']][featureLabel]['opened'] += 1
            weeks[issue['week_open']][specLabel]['opened'] += 1

            if 'week_closed' in issue:
                weeks[issue['week_closed']]['issue']['closed'] += 1
                weeks[issue['week_closed']][featureLabel]['closed'] += 1
                weeks[issue['week_closed']][specLabel]['closed'] += 1

data = []
index = []
total = 0
current = 0
for week in range(firstweek, len(weeks)):
    total += weeks[week]['issue']['opened']
    current += weeks[week]['issue']['opened'] - weeks[week]['issue']['closed']
    date = meetingone + (oneweek * week)
    if date <= meetingnow:
        row = [
            week, date,
            weeks[week]['issue']['opened'],
            weeks[week]['issue']['closed'],
            total, current, total - current]
        index.append(str(date)[0:10])
        data.append(row)

df = pd.DataFrame(data, index=index,
                  columns=["Week", "Date", "Opened", "Closed", "Total", "CurrentOpen", "CurrentClosed"])

g = sns.lmplot(data=df, x="Week", y="CurrentOpen")
g.set_axis_labels("Week", "Number of open issues")
plt.savefig(f"issues-open-{meetingnow.year}-{meetingnow.month:02}-{meetingnow.day:02}.png")
plt.clf()

data = []
current = {}
for spec in specifications:
    current[spec] = 0
    
for week in range(firstweek, len(weeks)):
    for spec in specifications:
        current[spec] += weeks[week][spec]['opened'] - weeks[week][spec]['closed']
    date = meetingone + (oneweek * week)
    if date <= meetingnow:
        for spec in specifications:
            for count in range(0, current[spec]):
                row = [week, str(date)[0:10], spec, 1]
                data.append(row)

df = pd.DataFrame(data, columns=["Week", "Date", "Spec", "CurrentOpen"])
sns.histplot(data=df, x="Date", hue="Spec", multiple="stack")

xticks = plt.gca().xaxis.get_major_ticks()
for tick in range(1, len(xticks)-1):
    if tick % 10 != 0:
        xticks[tick].set_visible(False)

plt.savefig(f"issues-by-spec-{meetingnow.year}-{meetingnow.month:02}-{meetingnow.day:02}.png")
plt.clf()

data = []
current = {}
for feature in features:
    current[feature] = 0
    
for week in range(firstweek, len(weeks)):
    for feature in features:
        current[feature] += weeks[week][feature]['opened'] - weeks[week][feature]['closed']
    date = meetingone + (oneweek * week)
    if date <= meetingnow:
        for feature in features:
            for count in range(0, current[feature]):
                row = [week, str(date)[0:10], feature, 1]
                data.append(row)

df = pd.DataFrame(data, columns=["Week", "Date", "Feature", "CurrentOpen"])
sns.histplot(data=df, x="Date", hue="Feature", multiple="stack")

xticks = plt.gca().xaxis.get_major_ticks()
for tick in range(1, len(xticks)-1):
    if tick % 10 != 0:
        xticks[tick].set_visible(False)

plt.savefig(f"issues-by-type-{meetingnow.year}-{meetingnow.month:02}-{meetingnow.day:02}.png")

