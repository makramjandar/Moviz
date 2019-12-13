
#----------------------------------------------------------------------------------
# standard library
#----------------------------------------------------------------------------------
import os

#----------------------------------------------------------------------------------
# Dash libs
#----------------------------------------------------------------------------------
import dash
from dash.dependencies import Input, Output
import dash_core_components as dcc
import dash_html_components as html
import plotly.figure_factory as ff
import plotly.graph_objs as go

#----------------------------------------------------------------------------------
# pydata stack
#----------------------------------------------------------------------------------
import pandas as pd

#----------------------------------------------------------------------------------
# set params
#----------------------------------------------------------------------------------
import pyodbc # db connector
import con as az # Azure credentials

#----------------------------------------------------------------------------------
# Connect Database
#----------------------------------------------------------------------------------
cnx = pyodbc.connect(
    server=az.server,
    database=az.database,
    user=az.user,
    tds_version=az.tds_version,
    password=az.password,
    port=az.password,
    driver=az.driver,
    Mars_Connection=az.con
)
#----------------------------------------------------------------------------------
# App config
#----------------------------------------------------------------------------------

app = dash.Dash()
#app = dash.Dash(__name__)
#server = app.server
app.config['suppress_callback_exceptions']=True

app.css.config.serve_locally = False
external_css = ["https://cdnjs.cloudflare.com/ajax/libs/milligram/1.3.0/milligram.css"]
for css in external_css:
    app.css.append_css({"external_url": css})

app.scripts.config.serve_locally = False
#external_js = ['https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js']
#for js in external_js:
#    app.scripts.append_script({'external_url': js})

#----------------------------------------------------------------------------------
# Model - Data Manipulation
#----------------------------------------------------------------------------------

def fetchData(q):
    result = pd.read_sql(
        sql=q,
        con=cnx
    )
    return result

def getGenres():
    '''Returns the list of genres that are stored in the database'''

    genreQuery = (
        f'''
        SELECT DISTINCT [Genre]
        FROM [tvfBI]()
        '''
    )
    Genres = fetchData(genreQuery)
    Genres =list(Genres['Genre'])
    return Genres


def getDirectors(Genre):
    '''Returns the directors of the datbase store'''

    directorsQuery = (
        f'''
        SELECT DISTINCT [Director]
        FROM [tvfBI]()
        WHERE Genre LIKE '{Genre}'
        '''
    )
    Directors = fetchData(directorsQuery)
    Directors = list(Directors['Director'])
    return Directors


def getMovies(Genre, Director):
    '''Returns all movies playing in the genre in the Director'''

    moviesQuery = (
        f'''
        SELECT DISTINCT [Movie]
        FROM [tvfBI]()
        WHERE Genre='{Genre}'
        AND Director='{Director}'
        '''
    )
    Movies = fetchData(moviesQuery)
    Movies = list(Movies['Movie'])
    return Movies


def getActorResults(Genre, Director, Movie):
    '''Returns actor results for the selected prompts'''

    resultsQuery = (
        f'''
        SELECT Year, Actor,  Gender, Role, Apparitions
        FROM [tvfBI]()
        WHERE Genre='{Genre}'
        AND Director='{Director}'
        AND Movie='{Movie}'
        '''
    )
    actorResults = fetchData(resultsQuery)
    return actorResults


def calculateDirectorSummary(results):
    record = results.groupby(by=['Gender'])['Year'].count()
    summary = pd.DataFrame(
        data={
            'M': record['M'],
            'F': record['F'],
            'Apparitions': results['Apparitions'].sum()
        },
        columns=['M', 'F'],
	index=results['Year'].unique(),
    )
    return summary

#----------------------------------------------------------------------------------
# View - Dashboard Layout
#----------------------------------------------------------------------------------

def generateTable(dataframe, max_rows=10):
    '''Given dataframe, return template generated using Dash components
    '''
    return html.Table(
        # Header
        [html.Tr([html.Th(col) for col in dataframe.columns])] +

        # Body
        [html.Tr([
            html.Td(dataframe.iloc[i][col]) for col in dataframe.columns
        ]) for i in range(min(len(dataframe), max_rows))]
    )

def onLoadGenreOptions():
    '''Actions to perform upon initial page load'''

    genre_options = (
        [{'label': Genre, 'value': Genre}
         for Genre in getGenres()]
    )
    return genre_options

app.layout = html.Div([
    
    # Page Header
    html.Div( [
        html.H1('I like 2 moviz, Moviz... ♪ ♫')
    ]),

    # Dropdown Grid
    html.Div([
        html.Div([
            # Select genre Dropdown
            html.Div([
                html.Div('Genre', className='three columns'),
                html.Div(dcc.Dropdown(id='genre-selector',
                                      options=onLoadGenreOptions()),
                         className='nine columns')
            ]),

            # Select Director Dropdown
            html.Div([
                html.Div('Director', className='three columns'),
                html.Div(dcc.Dropdown(id='director-selector'),
                         className='nine columns')
            ]),

            # Select Movie Dropdown
            html.Div([
                html.Div('Movie', className='three columns'),
                html.Div(dcc.Dropdown(id='movie-selector'),
                         className='nine columns')
            ]),
        ], className='six columns'),

        # Empty
        html.Div(className='six columns'),
    ], className='twleve columns'),

    # actor Results Grid
    html.Div([

        # actor Results Table
        html.Div(
            html.Table(id='actorResults'),
            className='six columns'
        ),

        # director Summary Table and Graph
        html.Div([
            # summary table
            dcc.Graph(id='directorSummary'),
            # style={},

        ], className='six columns')
    ]),
])


#----------------------------------------------------------------------------------
# Controller - Components Interactions
#----------------------------------------------------------------------------------

# Load directors in Dropdown
@app.callback(
    Output(component_id='director-selector', component_property='options'),
    [
        Input(component_id='genre-selector', component_property='value')
    ]
)
def populateDirectorSelector(Genre):
    Directors = getDirectors(Genre)
    return [
        {'label': Director, 'value': Director}
        for Director in Directors
    ]


# Load movies into dropdown
@app.callback(
    Output(component_id='movie-selector', component_property='options'),
    [
        Input(component_id='genre-selector', component_property='value'),
        Input(component_id='director-selector', component_property='value')
    ]
)
def populateMovieSelector(Genre, Director):
    Movies = getMovies(Genre, Director)
    return [
        {'label': Movie, 'value': Movie}
        for Movie in Movies
    ]


# Load actor results
@app.callback(
    Output(component_id='actorResults', component_property='children'),
    [
        Input(component_id='genre-selector', component_property='value'),
        Input(component_id='director-selector', component_property='value'),
        Input(component_id='movie-selector', component_property='value')
    ]
)
def loadActorResults(Genre, Director, Movie):
    results = getActorResults(Genre, Director, Movie)
    return generateTable(results, max_rows=50)


# Update director Summary Table
@app.callback(
    Output(component_id='directorSummary', component_property='figure'),
    [
        Input(component_id='genre-selector', component_property='value'),
        Input(component_id='director-selector', component_property='value'),
        Input(component_id='movie-selector', component_property='value')
    ]
)
def loadDirectorSummary(Genre, Director, Movie):
    results = getActorResults(Genre, Director, Movie)

    table = []
    if len(results) > 0:
        summary = calculateDirectorSummary(results)
        table = ff.create_table(summary)

    return table


# start erver
if __name__ == '__main__':
    app.run_server(
        debug=False,
        host='0.0.0.0',
        port=8050
    )

#if __name__ == '__main__':
#    app.run_server(debug=True)
